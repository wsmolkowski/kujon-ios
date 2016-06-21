//
//  CalendarViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 21/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import CalendarLib

class CalendarViewController: MGCDayPlannerViewController {

    let calendarDateFormant = "eee d"
    let dateFormatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()


        self.edgesForExtendedLayout = UIRectEdge.None
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(CalendarViewController.back))
        self.dayPlannerView.backgroundColor = UIColor.whiteColor()
        self.dayPlannerView.backgroundView  = UIView(frame: CGRectZero)
        self.dayPlannerView.backgroundView.backgroundColor = UIColor.whiteColor()
//        self.dayPlannerView.dayHeaderHeight = 60;
        self.dayPlannerView.numberOfVisibleDays = 3
        self.dayPlannerView.dateFormat = calendarDateFormant

        dateFormatter.dateFormat = calendarDateFormant
        let ekEventStore = EKEventStore()
    }


    func back(){
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
        return super.dayPlannerView(view, numberOfEventsOfType: type, atDate: date)
    }


}
