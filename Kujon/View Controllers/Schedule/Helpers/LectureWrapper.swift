//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LectureWrapper: CellHandlingStrategy,ShowCourseDetailsDelegate {

    let lecture: Lecture
    let startDate: String
    let startTime: String
    let endTime: String
    let startNSDate: Date
    let endNSDate: Date
    let mothYearDate: String
    var myCellHandler: LectureCellHandler! = nil
    let monthYearNSDate: Date
    weak var controller:UINavigationController! = nil

    init(lecture: Lecture) {
        self.lecture = lecture
        self.startNSDate = Date.stringToDateWithClock(lecture.startTime) ?? Date()
        self.endNSDate = Date.stringToDateWithClock(lecture.endTime) ?? Date()
        self.startDate = startNSDate.dateToStringSchedule()
        self.startTime = startNSDate.dateHoursToString()
        self.endTime = endNSDate.dateHoursToString()
        self.mothYearDate = startNSDate.getMonthYearString()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: startNSDate)
        self.monthYearNSDate = calendar.date(from: components)!
    }

    func giveMyStrategy() -> CellHandlerProtocol {
        if (self.myCellHandler == nil) {
            self.myCellHandler = LectureCellHandler(lectureWrapper: self)
        }
        return myCellHandler


    }

    func giveMeMyCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewController.LectureCellId, for: indexPath)
    }


    func amILectureWrapper() -> Bool {
        return true
    }

    func handleClick(_ controller: UINavigationController?) {
        if (controller != nil) {
            let popController = CoursePopUpViewController(nibName: "CoursePopUpViewController", bundle: Bundle.main)
            popController.modalPresentationStyle = .overCurrentContext
            controller?.present(popController, animated: false, completion: {
                popController.showAnimate();
            })
            popController.delegate = self
            self.controller = controller
            popController.showInView(withLecture: self)
        }
    }


    func showCourseDetails() {
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.courseId = lecture.courseId
        self.controller?.pushViewController(courseDetails, animated: true)
        

        
    }


}
