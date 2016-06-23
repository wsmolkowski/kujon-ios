//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LectureWrapper:CellHandlingStrategy {

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
        self.startDate = startNSDate.dateToString()
        self.startTime = startNSDate.dateHoursToString()
        self.endTime = endNSDate.dateHoursToString()
        self.mothYearDate = startNSDate.getMonthYearString()
    }

    func giveMeCellHandler() -> CellHandlerProtocol {
        return LectureCellHandler(self)
    }

}
