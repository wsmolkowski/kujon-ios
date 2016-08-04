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
        LectureProviderDelegate  {

    let calendarDateFormant = "MMMM d"
    let dateFormatter = NSDateFormatter()
    weak var delegate: NavigationMenuProtocol! = nil
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()
    var lastQueryDate: NSDate! = nil
    var lectureProvider  = ProvidersProviderImpl.sharedInstance.provideLectureProvider()
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
        self.dayPlannerView.backgroundColor = UIColor.whiteColor()
        self.dayPlannerView.backgroundView = UIView(frame: CGRectZero)
        self.dayPlannerView.backgroundView.backgroundColor = UIColor.whiteColor()
        self.dayPlannerView.numberOfVisibleDays = 3
        self.dayPlannerView.dateFormat = calendarDateFormant
        (self.dayPlannerView as MGCDayPlannerView).hourRange  = NSRange(location:6,length:16)
        dateFormatter.dateFormat = calendarDateFormant
        lectureProvider.delegate = self
        let ekEventStore = EKEventStore()
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
            let key = key2.getMonthYearString();
            var dict = dicMonthYear[key2]!.groupBy {
                $0.startDate
            }
            for day in dict.keys {
                onlyLectureDictionary[day] = dict[day]
            }
        }

    }

    func onErrorOccurs() {
        ToastView.showInParent(self.navigationController?.view,withText: StringHolder.errorOccures , forDuration: 2.0)
    }


    func onErrorOccurs(text: String) {
        ToastView.showInParent(self.navigationController?.view,withText: text, forDuration: 2.0)
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


    override func dayPlannerView(_ view: MGCDayPlannerView!, numberOfEventsOfType type: MGCEventType, atDate date: NSDate!) -> Int {
        if(date.isGreaterThanDate(lastQueryDate.dateByAddingTimeInterval(60 * 60 * 24 * 7))){
            lastQueryDate = date.getStartOfTheWeek()
            askForData()
        }
        switch (type) {
        case MGCEventType.TimedEventType:
            if var list = onlyLectureDictionary[date.dateToString()] {
                return list.count
            }
            return 0
        default: return 0
        }
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, dateRangeForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCDateRange! {
        if var list = onlyLectureDictionary[date.dateToString()] {
            let lecture = list[Int(index)] as! LectureWrapper;
            return MGCDateRange(start: lecture.startNSDate, end: lecture.endNSDate)
        }
        return nil
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCEventView! {
        if var list = onlyLectureDictionary[date.dateToString()] {
            var eventView = MGCStandardEventView()
            let lecture = list[Int(index)] as! LectureWrapper;
            eventView.color = UIColor.kujonBlueColorWithAplha()
            eventView.title = lecture.lecture.name
            eventView.detail = lecture.lecture.buldingName
            eventView.selected = false
            return eventView
        }


        return nil
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, didSelectEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) {
        if var list = onlyLectureDictionary[date.dateToString()] {
            let lecture = list[Int(index)] as! LectureWrapper;
            lecture.handleClick(self.navigationController)
        }
    }


}
