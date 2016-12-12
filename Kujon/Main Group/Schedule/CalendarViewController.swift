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
    var lastQueryDate: Date! = nil
    var veryFirstDate: Date! = nil
    var lectureProvider = ProvidersProviderImpl.sharedInstance.provideLectureProvider()
    private let floatingButtonDelegate = FloatingButtonDelegate()
    var spinner: SpinnerView!
    private var isReload: Bool = false


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
        if (lastQueryDate == nil) {
            lastQueryDate = Date.getCurrentStartOfWeek()
        }
        lectureProvider.loadLectures(lastQueryDate.dateToString())
        veryFirstDate = lastQueryDate
        dateFormatter.dateFormat = calendarDateFormant
        lectureProvider.delegate = self

        self.dayPlannerView.scroll(to: lastQueryDate, options: MGCDayPlannerScrollType.dateTime, animated: false)
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        floatingButtonDelegate.viewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func onTodayClick() {
        self.dayPlannerView.scroll(to: Date(), options: MGCDayPlannerScrollType.date, animated: false)

    }

    func reload() {
        onlyLectureDictionary = [:]
        dayPlannerView.reloadAllEvents()
        isReload = true
        askForData(Date())
    }

    private func addSpinnerView(hidden:Bool) {
        spinner = SpinnerView()
        spinner.frame.origin = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        spinner.frame.size = CGSize(width: 50.0, height: 50.0)
        spinner.isHidden = hidden
        view.insertSubview(spinner, aboveSubview: dayPlannerView)
    }

    private func askForData(_ firstDate: Date! = nil) {
        spinner.isHidden = false
        if (firstDate != nil) {
            lectureProvider.loadLectures(firstDate.dateToString())
        } else {
            lectureProvider.loadLectures(self.lastQueryDate.dateToString())
        }
    }

    func onLectureLoaded(_ lectures: Array<Lecture>) {
        let wrappers = lectures.map {
            lecture in LectureWrapper(lecture: lecture)
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
            self.dayPlannerView.scroll(to: Date(), options: MGCDayPlannerScrollType.dateTime, animated: false)
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
        if (date.isGreaterThanDate(lastQueryDate.addingTimeInterval(60 * 60 * 24 * 7))) {
            lastQueryDate = date.getStartOfTheWeek()
            askForData()
        }
        if (date.isLessThanDate(veryFirstDate)) {
            veryFirstDate = veryFirstDate.addingTimeInterval(60 * 60 * 24 * 7 * -1)
            askForData(veryFirstDate)
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
        if var list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            return MGCDateRange(start: lecture.startNSDate as Date!, end: lecture.endNSDate as Date!)
        }
        return nil
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOf type: MGCEventType, at index: UInt, date: Date!) -> MGCEventView! {
        if var list = getListOfLecturesWrappers(date) {
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
        if var list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            lecture.handleClick(self.navigationController)
        }
    }

    private func getListOfLecturesWrappers(_ date: Date) -> Array<LectureWrapper>! {
        return onlyLectureDictionary[date.dateToStringSchedule()]
    }

}
