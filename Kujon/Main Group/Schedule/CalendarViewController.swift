//
//  CalendarViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 21/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import CalendarLib

class CalendarViewController: MGCDayPlannerViewController, NavigationDelegate {

    let calendarDateFormant = "eee d"
    let dateFormatter = NSDateFormatter()
    weak var delegate: NavigationMenuProtocol! = nil
    var onlyLectureDictionary: Dictionary<String, [LectureWrapper]> = Dictionary()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CalendarViewController.openDrawer), andTitle: StringHolder.schedule)
        let openCalendarButton = UIBarButtonItem(title: "list", style: UIBarButtonItemStyle.Plain, target: self,
                action: #selector(CalendarViewController.openList))
        self.navigationItem.rightBarButtonItem = openCalendarButton
        self.edgesForExtendedLayout = UIRectEdge.None
        self.dayPlannerView.backgroundColor = UIColor.whiteColor()
        self.dayPlannerView.backgroundView = UIView(frame: CGRectZero)
        self.dayPlannerView.backgroundView.backgroundColor = UIColor.whiteColor()
//        self.dayPlannerView.dayHeaderHeight = 60;
        self.dayPlannerView.numberOfVisibleDays = 3
        self.dayPlannerView.dateFormat = calendarDateFormant
//        self.dayPlannerView
        dateFormatter.dateFormat = calendarDateFormant
        let ekEventStore = EKEventStore()
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func openList() {
        self.navigationController?.popViewControllerAnimated(true)
    }

//    override func dayPlannerView(_ view: MGCDayPlannerView!, attributedStringForDayHeaderAtDate date: NSDate!) -> NSAttributedString! {
//        let dayStr = dateFormatter.stringFromDate(date)
//        let font = UIFont(name:"Helvetica Neue",size: 15)
//
//        var attrStr = NSMutableAttributedString(string: dayStr)
//        attrStr.addAttribute(NSFontAttributeName,value: font!,range: NSRangeFromString(dayStr))
//
//        var para = NSMutableParagraphStyle()
//        para.alignment = NSTextAlignment.Center
//        attrStr.addAttribute(NSParagraphStyleAttributeName,value: para,range: NSRangeFromString(dayStr))
//        return attrStr
//    }
//

    override func dayPlannerView(_ view: MGCDayPlannerView!, viewForEventOfType type: MGCEventType, atIndex index: UInt, date: NSDate!) -> MGCEventView! {
        return super.dayPlannerView(view, viewForEventOfType: type, atIndex: index, date: date)
    }

    override func dayPlannerView(_ view: MGCDayPlannerView!, numberOfEventsOfType type: MGCEventType, atDate date: NSDate!) -> Int {
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
            let lecture = list[index as! Int] as! LectureWrapper;
            return MGCDateRange(start: lecture.startNSDate,end: lecture.endNSDate)
        }
        return nil
    }


    override func dayPlannerView(_ view: MGCDayPlannerView!, viewForNewEventOfType type: MGCEventType, atDate date: NSDate!) -> MGCEventView! {
        var eventView  = MGCEventView()
        eventView.selected = false

        return eventView
    }



}
