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

    static func dateToString(date: NSDate) -> String {
        return getDateFormatter().stringFromDate(date)
    }


    private static func getDateFormatter() -> NSDateFormatter {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }

}
