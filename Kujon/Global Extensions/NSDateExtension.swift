//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

extension Date {
    private static let dateFormatter = DateFormatter()
    private static let dateFormat = "yyyy-MM-dd"
    private static let dateFormatSchedule = "EEEE d MMMM ,yyyy"
    private static let dateFormatDayMonth = "dd \n MMM"
    private static let dateFormatMonth = "MMMM"
    private static let dateFormatMonth2 = "LLLL"
    private static let dateFormatYear = "yyyy"
    private static let dateFormatDay = "EEEE"
    private static let dateFormatWithClock = "yyyy-MM-dd HH:mm:ss"
    private static let dateFormatOnlyTime = "HH:mm"
    private static let dateFileEvent = "d.MM.yyyy"
    private static let dateTimeFileEvent = "d.MM.yyyy, HH:mm"

    static func stringToDate(_ dateString: String) -> Date! {
        return getDateFormatter().date(from: dateString)
    }

    static func stringToDateWithClock(_ dateString: String) -> Date? {
        return getDateFormatter(Date.dateFormatWithClock).date(from: dateString)
    }

    func dateToString() -> String {
        return Date.getDateFormatter().string(from: self)
    }

    func toAPIDateString() -> String {
        return Date.getDateFormatter(Date.dateFormatWithClock).string(from: self)
    }

    func dateToStringSchedule() -> String {
        return Date.getDateFormatter(Date.dateFormatSchedule).string(from: self)
    }
    func dateHoursToString() -> String {
        return Date.getDateFormatter(Date.dateFormatOnlyTime).string(from: self)
    }
    func toFileEventString() -> String {
        return Date.getDateFormatter(Date.dateFileEvent).string(from: self)
    }
    func toFileEventDateTime() -> String {
        return Date.getDateFormatter(Date.dateTimeFileEvent).string(from: self)
    }
    func toFileEventTime() -> String {
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

    func  getMonth()->String{
        return Date.getDateFormatter(Date.dateFormatMonth2).string(from: self)
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


    private static func getDateFormatter(_ format: String = dateFormat) -> DateFormatter {
        dateFormatter.dateFormat = format
        return dateFormatter
    }

    func compareMonth(_ dateToCompare: Date)->Int{
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let year1 = calendar!.component(NSCalendar.Unit.year, from: self)
        let year2 = calendar!.component(NSCalendar.Unit.year, from: dateToCompare)
        if(year1>year2){
            return -1;
        }else if(year1<year2){
            return 1;
        }else {
            let monthOfYear1 = calendar!.component(NSCalendar.Unit.month, from: self)
            let monthOfYear2 = calendar!.component(NSCalendar.Unit.month, from: dateToCompare)
            if(monthOfYear2==monthOfYear1){
                return 0;
            }else if(monthOfYear1>monthOfYear2){
                return -1;
            }else {
                return 1;
            }
        }
    }

    func addMonth(number: Int)->Date?{
        let result:Date? = Calendar.current.date(byAdding: .month, value: number, to: self)
        return result
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

    func numberOfDaysUntilDateTime(toDateTime: Date, calendar: Calendar) -> Int {
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: toDateTime)
        let difference = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return difference.day!
    }

    static func stringFromFormatWithClockString(_ dateString:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateFormatWithClock
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from:dateString) {
            dateFormatter.locale = Locale(identifier: "pl_PL")
            dateFormatter.dateFormat = "d MMMM YYYY, HH:MM"
            return dateFormatter.string(from:date)
        }
        return nil
    }

    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

