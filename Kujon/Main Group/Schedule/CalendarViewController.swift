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
    let dateFormatter = NSDateFormatter()
    weak var delegate: NavigationMenuProtocol! = nil
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()
    var lastQueryDate: NSDate! = nil
    var lectureProvider = ProvidersProviderImpl.sharedInstance.provideLectureProvider()
    private let floatingButtonDelegate = FloatingButtonDelegate()


    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CalendarViewController.openDrawer), andTitle: StringHolder.schedule)
        let openCalendarButton = UIBarButtonItem(image: UIImage(named: "calendar-list"), style: UIBarButtonItemStyle.Plain, target: self,
                action: #selector(CalendarViewController.openList))
        self.navigationItem.rightBarButtonItem = openCalendarButton
        self.edgesForExtendedLayout = UIRectEdge.None
        self.dayPlannerView.numberOfVisibleDays = 3
        self.dayPlannerView.daySeparatorsColor = UIColor.calendarSeparatorColor()
        self.dayPlannerView.timeSeparatorsColor = UIColor.calendarSeparatorColor()
        self.dayPlannerView.dateFormat = calendarDateFormant
        (self.dayPlannerView as MGCDayPlannerView).hourRange = NSRange(location: 6, length: 16)
        dateFormatter.dateFormat = calendarDateFormant
        lectureProvider.delegate = self
        self.dayPlannerView.scrollToDate(lastQueryDate, options: MGCDayPlannerScrollType.Date, animated: false)
        _ = EKEventStore()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        lectureProvider.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.floatingButtonDelegate.viewWillAppear(self, selector: #selector(CalendarViewController.onTodayClick))
    }

    override func viewWillDisappear(animated: Bool) {
        floatingButtonDelegate.viewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func onTodayClick() {
        self.dayPlannerView.scrollToDate(NSDate(), options: MGCDayPlannerScrollType.Date, animated: false)

    }


    private func askForData() {
        lectureProvider.loadLectures(lastQueryDate.dateToString())
    }

    func onLectureLoaded(lectures: Array<Lecture>) {
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

    }

    func onErrorOccurs() {
        ToastView.showInParent(self.navigationController?.view, withText: StringHolder.errorOccures, forDuration: 2.0)
    }


    func onErrorOccurs(text: String) {
        ToastView.showInParent(self.navigationController?.view, withText: text, forDuration: 2.0)
    }


    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func isSecond() -> Bool {
        return true
    }

    func openList() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    override func dayPlannerView(view: MGCDayPlannerView!, numberOfEventsOfType type: MGCEventType, atDate date: NSDate!) -> Int {
        if (date.isGreaterThanDate(lastQueryDate.dateByAddingTimeInterval(60 * 60 * 24 * 7))) {
            lastQueryDate = date.getStartOfTheWeek()
            askForData()
        }
        switch (type) {
        case MGCEventType.TimedEventType:
            if let list = getListOfLecturesWrappers(date) {
                return list.count
            }
            return 0
        default: return 0
        }
    }

    override func dayPlannerView(view: MGCDayPlannerView!, dateRangeForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCDateRange! {
        if var list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            return MGCDateRange(start: lecture.startNSDate, end: lecture.endNSDate)
        }
        return nil
    }

    override func dayPlannerView(view: MGCDayPlannerView!, viewForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCEventView! {
        if var list = getListOfLecturesWrappers(date) {
            let eventView = MyEventView()
            let lecture = list[Int(index)];
            eventView.myBackgrounColor = UIColor.kujonCalendarBlue()
            eventView.fontColor = UIColor.blackColor()
            eventView.title = lecture.startTime + " " + lecture.endTime + "\n" + lecture.lecture.courseName
            eventView.font = UIFont.kjnTextStyleFontSmall()
            eventView.detail = lecture.lecture.buldingName
            eventView.selected = false
            return eventView
        }


        return nil
    }

    override func dayPlannerView(view: MGCDayPlannerView!, didSelectEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) {
        if var list = getListOfLecturesWrappers(date) {
            let lecture = list[Int(index)];
            lecture.handleClick(self.navigationController)
        }
    }

    private func getListOfLecturesWrappers(date: NSDate) -> Array<LectureWrapper>! {
        return onlyLectureDictionary[date.dateToStringSchedule()]
    }

}
