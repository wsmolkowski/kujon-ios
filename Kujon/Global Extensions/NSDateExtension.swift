//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

extension Date {
    fileprivate static let dateFormatter = DateFormatter()
    fileprivate static let dateFormat = "yyyy-MM-dd"
    fileprivate static let dateFormatSchedule = "EEEE d MMMM ,yyyy"
    fileprivate static let dateFormatDayMonth = "dd \n MMM"
    fileprivate static let dateFormatMonth = "MMMM"
    fileprivate static let dateFormatYear = "yyyy"
    fileprivate static let dateFormatDay = "EEEE"
    fileprivate static let dateFormatWithClock = "yyyy-MM-dd HH:mm:ss"
    fileprivate static let dateFormatOnlyTime = "HH:mm"


    static func stringToDate(_ dateString: String) -> Date! {
        return getDateFormatter().date(from: dateString)
    }

    static func stringToDateWithClock(_ dateString: String) -> Date! {
        return getDateFormatter(Date.dateFormatWithClock).date(from: dateString)
    }

    func dateToString() -> String {
        return Date.getDateFormatter().string(from: self)
    }

    func dateToStringSchedule() -> String {
        return Date.getDateFormatter(Date.dateFormatSchedule).string(from: self)
    }
    func dateHoursToString() -> String {
        return Date.getDateFormatter(Date.dateFormatOnlyTime).string(from: self)
    }

    func dateWithDayToString() -> String {
        return Date.getDateFormatter(Date.dateFormatDay).string(from: self) + " " + Date.getDateFormatter().string(from: self)
    }

    func getMonthYearString() -> String {
        return Date.getDateFormatter(Date.dateFormatMonth).string(from: self) + " " + Date.getDateFormatter(Date.dateFormatYear).string(from: self)
    }

    func  getDayMonth()->String{
        return Date.getDateFormatter(Date.dateFormatDayMonth).string(from: self)
    }

    static func getCurrentStartOfWeek() -> Date {
        let today = Date()
        var gregorian = Calendar.current
        gregorian.firstWeekday = 2
        let weekdayComponents = (gregorian as NSCalendar).component(.weekday, from: today)
        var componentsToSubtact = DateComponents()
        componentsToSubtact.day = -weekdayComponents + gregorian.firstWeekday
        return (gregorian as NSCalendar).date(byAdding: componentsToSubtact, to: today, options: .matchStrictly)!
    }
    func getStartOfTheWeek() -> Date {
        let today = self
        var gregorian = Calendar.current
        gregorian.firstWeekday = 2
        let weekdayComponents = (gregorian as NSCalendar).component(.weekday, from: today)
        var componentsToSubtact = DateComponents()
        componentsToSubtact.day = -weekdayComponents + gregorian.firstWeekday
        return (gregorian as NSCalendar).date(byAdding: componentsToSubtact, to: today, options: .matchStrictly)!
    }


    fileprivate static func getDateFormatter(_ format: String = dateFormat) -> DateFormatter {
        dateFormatter.dateFormat = format
        return dateFormatter
    }




    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }

    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)

        //Return Result
        return dateWithDaysAdded
    }

    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)

        //Return Result
        return dateWithHoursAdded
    }

    func numberOfDaysUntilDateTime(_ toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }

        var fromDate: Date?, toDate: Date?

        (calendar as NSCalendar).range(of: .day, start: &fromDate as NSDate?, interval: nil, for: self)
        (calendar as NSCalendar).range(of: .day, start: &toDate as NSDate?, interval: nil, for: toDateTime)

        let difference = (calendar as NSCalendar).components(.day, from: fromDate!, to: toDate!, options: [])
        return difference.day!
    }
}

