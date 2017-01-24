//
//  CalendarViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 21/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import CalendarLib

class CalendarViewController: MGCDayPlannerViewController,
        NavigationDelegate,
        LectureProviderDelegate {

    let calendarDateFormant = "EEE d/M"
    let dateFormatter = DateFormatter()
    weak var delegate: NavigationMenuProtocol! = nil
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()
    var lastQueryDate: Date? = nil
    var veryFirstDate: Date? = nil
    var lectureProvider = ProvidersProviderImpl.sharedInstance.provideLectureProvider()
    private let floatingButtonDelegate = FloatingButtonDelegate()
    var spinner: SpinnerView! = SpinnerView()
    private var isReload: Bool = false
    var lecturerId: String? = nil


    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CalendarViewController.openDrawer), andTitle: StringHolder.schedule)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "reload-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(CalendarViewController.reload))


        self.edgesForExtendedLayout = UIRectEdge()
        self.dayPlannerView.numberOfVisibleDays = 3
        self.dayPlannerView.daySeparatorsColor = UIColor.calendarSeparatorColor()
        self.dayPlannerView.timeSeparatorsColor = UIColor.calendarSeparatorColor()
        self.dayPlannerView.dateFormat = calendarDateFormant
        self.dayPlannerView.showsAllDayEvents = false
        dayPlannerView.hourSlotHeight = 50.0
        (self.dayPlannerView as MGCDayPlannerView).hourRange = NSRange(location: 6, length: 16)
        lectureProvider.setLecturer(lecturerId: lecturerId)
        if lastQueryDate == nil {
            lastQueryDate = Date.getCurrentStartOfWeek()
        }
        if let lastQueryDate = lastQueryDate {
            lectureProvider.loadLectures(lastQueryDate)
        }
        veryFirstDate = lastQueryDate
        dateFormatter.dateFormat = calendarDateFormant
        lectureProvider.delegate = self

        _ = EKEventStore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lectureProvider.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.floatingButtonDelegate.viewWillAppear(self, selector: #selector(CalendarViewController.onTodayClick))
        addSpinnerView(hidden: true)
        self.dayPlannerView.scroll(to: Date(), options: MGCDayPlannerScrollType.dateTime, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        floatingButtonDelegate.viewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func onTodayClick() {
        self.dayPlannerView.scroll(to: Date(), options: MGCDayPlannerScrollType.dateTime, animated: true)

    }

    func reload() {
        onlyLectureDictionary = [:]
        lectureProvider.reload()
        dayPlannerView.reloadAllEvents()
        isReload = true
        askForData(Date())
    }

    private func addSpinnerView(hidden: Bool) {
        spinner.frame.origin = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        spinner.frame.size = CGSize(width: 50.0, height: 50.0)
        spinner.isHidden = hidden
        navigationController?.view.addSubview(spinner)
    }

    private func askForData(_ firstDate: Date! = nil) {
        spinner.isHidden = false
        if let firstDate = firstDate {
            lectureProvider.loadLectures(firstDate)
            return
        }
        if let lastQueryDate = lastQueryDate {
            lectureProvider.loadLectures(lastQueryDate)
        }
    }


    func onLectureLoaded(_ lectures: Array<Lecture>, date: Date) {
        if let loadedDate = (self.dayPlannerView as MGCDayPlannerView).visibleDays.start {
            if (date.compareMonth(loadedDate) == 0 && lectures.count == 0) {
                spinner.isHidden = true
                ToastView.showInParent(self.navigationController?.view, withText: date.getMonth() + StringHolder.noLecturesIn, forDuration: 2.0)
            } else {
                self.handleIncomingLectures(lectures)
            }
        }
    }


    private func handleIncomingLectures(_ lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in
            LectureWrapper(lecture: lecture)
        }
        let dicMonthYear = wrappers.groupBy {
            $0.monthYearNSDate
        }
        let sortedKeys = dicMonthYear.keys

        sortedKeys.forEach {
            key2 in
            _ = key2.getMonthYearString();
            var dict = dicMonthYear[key2]!.groupBy {
                $0.startDate
            }
            for day in dict.keys {
                onlyLectureDictionary[day] = dict[day]
            }
        }
        spinner.isHidden = true
        dayPlannerView.reloadAllEvents()
        if isReload {
            self.dayPlannerView.scroll(to: Date(), options: MGCDayPlannerScrollType.dateTime, animated: true)
            lastQueryDate = Date.getCurrentStartOfWeek()
            isReload = false
        }
    }


    func onErrorOccurs() {
        spinner.isHidden = true
        ToastView.showInParent(self.navigationController?.view, withText: StringHolder.errorOccures, forDuration: 2.0)
    }


    func onErrorOccurs(_ text: String) {
        spinner.isHidden = true
        ToastView.showInParent(self.navigationController?.view, withText: text, forDuration: 2.0)
    }


    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func isSecond() -> Bool {
        return false
    }

    func openList() {
        let _ = self.navigationController?.popViewController(animated: true)
    }


    override func dayPlannerView(_ view: MGCDayPlannerView!, numberOfEventsOf type: MGCEventType, at date: Date!) -> Int {

        if let lastQueryDate = lastQueryDate,
           let date = date, lastQueryDate.compareMonth(date) > 0 {
            self.lastQueryDate = lastQueryDate.addMonth(number: 1)
            askForData()
        }
        if let veryFirstDate = veryFirstDate, veryFirstDate.compareMonth(date) < 0 {
            if let newVeryFirstDate = veryFirstDate.addMonth(number: -1) {
                self.veryFirstDate = newVeryFirstDate
                askForData(self.veryFirstDate)
            }
        }
        switch (type) {
        case MGCEventType.timedEventType:
            if let list = getListOfLecturesWrappers(date) {
                return list.count
            }
            return 0
        default: return 0
        }
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, dateRangeForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCDateRange! {
        if let date = date, let list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            return MGCDateRange(start: lecture.startNSDate as Date!, end: lecture.endNSDate as Date!)
        }
        return nil
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCEventView! {
        if let date = date, let list = getListOfLecturesWrappers(date) {
            let eventView = MyEventView()
            let lecture = list[Int(index)];
            eventView.myBackgrounColor = UIColor.kujonCalendarBlue()
            eventView.fontColor = UIColor.black
            eventView.title = lecture.startTime + " " + lecture.endTime + "\n" + lecture.lecture.courseName
            eventView.font = UIFont.kjnTextStyleFontSmall()
            eventView.detail = lecture.lecture.buldingName
            eventView.selected = false
            return eventView
        }


        return nil
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, didSelectEventOf type: MGCEventType, at index: UInt, date: Date!) {
        if let date = date, let list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            lecture.handleClick(self.navigationController)
        }
    }

    private func getListOfLecturesWrappers(_ date: Date) -> Array<LectureWrapper>! {
        return onlyLectureDictionary[date.dateToStringSchedule()]
    }

}
