//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LectureWrapper {

    let lecture: Lecture
    let startDate: String
    let startTime: String
    let endTime: String
    let startNSDate: NSDate
    let endNSDate: NSDate
    let mothYearDate : String

    init(lecture: Lecture) {
        self.lecture = lecture
        self.startNSDate = NSDate.stringToDateWithClock(lecture.startTime)
        self.endNSDate = NSDate.stringToDateWithClock(lecture.endTime)
        self.startDate = start.dateToString()
        self.startTime = start.dateHoursToString()
        self.endTime = end.dateHoursToString()
        self.mothYearDate = NSDate.getMonthYearString()
    }
}
