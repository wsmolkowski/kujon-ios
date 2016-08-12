//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

extension NSDate {
    private static let dateFormatter = NSDateFormatter()
    private static let dateFormat = "yyyy-MM-dd"
    private static let dateFormatSchedule = "EEEE d MMMM ,yyyy"
    private static let dateFormatDayMonth = "dd \n MMM"
    private static let dateFormatMonth = "MMMM"
    private static let dateFormatYear = "yyyy"
    private static let dateFormatDay = "EEEE"
    private static let dateFormatWithClock = "yyyy-MM-dd HH:mm:ss"
    private static let dateFormatOnlyTime = "HH:mm"


    static func stringToDate(dateString: String) -> NSDate! {
        return getDateFormatter().dateFromString(dateString)
    }

    static func stringToDateWithClock(dateString: String) -> NSDate! {
        return getDateFormatter(NSDate.dateFormatWithClock).dateFromString(dateString)
    }

    func dateToString() -> String {
        return NSDate.getDateFormatter().stringFromDate(self)
    }

    func dateToStringSchedule() -> String {
        return NSDate.getDateFormatter(NSDate.dateFormatSchedule).stringFromDate(self)
    }
    func dateHoursToString() -> String {
        return NSDate.getDateFormatter(NSDate.dateFormatOnlyTime).stringFromDate(self)
    }

    func dateWithDayToString() -> String {
        return NSDate.getDateFormatter(NSDate.dateFormatDay).stringFromDate(self) + " " + NSDate.getDateFormatter().stringFromDate(self)
    }

    func getMonthYearString() -> String {
        return NSDate.getDateFormatter(NSDate.dateFormatMonth).stringFromDate(self) + " " + NSDate.getDateFormatter(NSDate.dateFormatYear).stringFromDate(self)
    }

    func  getDayMonth()->String{
        return NSDate.getDateFormatter(NSDate.dateFormatDayMonth).stringFromDate(self)
    }

    static func getCurrentStartOfWeek() -> NSDate {
        let today = NSDate()
        let gregorian = NSCalendar.currentCalendar()
        gregorian.firstWeekday = 2
        let weekdayComponents = gregorian.component(.Weekday, fromDate: today)
        let componentsToSubtact = NSDateComponents()
        componentsToSubtact.day = -weekdayComponents + gregorian.firstWeekday
        return gregorian.dateByAddingComponents(componentsToSubtact, toDate: today, options: .MatchStrictly)!
    }
    func getStartOfTheWeek() -> NSDate {
        let today = self
        let gregorian = NSCalendar.currentCalendar()
        gregorian.firstWeekday = 2
        let weekdayComponents = gregorian.component(.Weekday, fromDate: today)
        let componentsToSubtact = NSDateComponents()
        componentsToSubtact.day = -weekdayComponents + gregorian.firstWeekday
        return gregorian.dateByAddingComponents(componentsToSubtact, toDate: today, options: .MatchStrictly)!
    }


    private static func getDateFormatter(format: String = dateFormat) -> NSDateFormatter {
        dateFormatter.dateFormat = format
        return dateFormatter
    }




    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }

    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)

        //Return Result
        return dateWithDaysAdded
    }

    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)

        //Return Result
        return dateWithHoursAdded
    }

    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }

        var fromDate: NSDate?, toDate: NSDate?

        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)

        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
}

