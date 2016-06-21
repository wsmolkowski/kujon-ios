//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

extension NSDate {
    private static let dateFormatter = NSDateFormatter()
    private static let dateFormat = "yyyy-MM-dd"

    static func stringToDate(dateString: String) -> NSDate! {
        return getDateFormatter().dateFromString(dateString)
    }

     func dateToString() -> String {
        return NSDate.getDateFormatter().stringFromDate(self)
    }

    static func getCurrentStartOfWeek() -> NSDate {
        let today = NSDate()
        let gregorian = NSCalendar.currentCalendar()
        gregorian.firstWeekday = 2
        let weekdayComponents = gregorian.component(.Weekday, fromDate: today)
        var componentsToSubtact = NSDateComponents()
        componentsToSubtact.day = -weekdayComponents + gregorian.firstWeekday
        return gregorian.dateByAddingComponents(componentsToSubtact,toDate: today, options: .MatchStrictly)!
    }


    private static func getDateFormatter() -> NSDateFormatter {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }

}
