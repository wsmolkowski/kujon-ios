//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LectureWrapper: CellHandlingStrategy {

    let lecture: Lecture
    let startDate: String
    let startTime: String
    let endTime: String
    let startNSDate: NSDate
    let endNSDate: NSDate
    let mothYearDate: String
    var myCellHandler: LectureCellHandler! = nil

    init(lecture: Lecture) {
        self.lecture = lecture
        self.startNSDate = NSDate.stringToDateWithClock(lecture.startTime)
        self.endNSDate = NSDate.stringToDateWithClock(lecture.endTime)
        self.startDate = startNSDate.dateToString()
        self.startTime = startNSDate.dateHoursToString()
        self.endTime = endNSDate.dateHoursToString()
        self.mothYearDate = startNSDate.getMonthYearString()
    }

    func giveMyStrategy() -> CellHandlerProtocol {
        if (self.myCellHandler == nil) {
            self.myCellHandler = LectureCellHandler(lectureWrapper: self)
        }
        return myCellHandler


    }

    func giveMeMyCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(ScheduleTableViewController.LectureCellId, forIndexPath: indexPath)
    }


    func amILectureWrapper() -> Bool {
        return true
    }

    func handleClick(controller: UINavigationController?) {
        if (controller != nil) {
            let popController = CoursePopUpViewController(nibName: "CoursePopUpViewController", bundle: NSBundle.mainBundle())
            popController.modalPresentationStyle = .OverCurrentContext
            controller?.presentViewController(popController, animated: false, completion: {
                popController.showAnimate();
            })
            popController.showInView(withLecture: self)
        }
    }


}
