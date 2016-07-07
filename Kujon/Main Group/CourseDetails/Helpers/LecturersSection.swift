//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LecturersSection: SectionHelperProtocol {
    var list: Array<SimpleUser>! = Array()
    func fillUpWithData(courseDetails: CourseDetails) {
        if (courseDetails.lecturers != nil) {
            list = courseDetails.lecturers
        }
    }

    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: getMyCellId())
    }

    func getSectionTitle() -> String {
        return StringHolder.leadingLecturers
    }

    func getSectionSize() -> Int {
        return list.count
    }

    func getRowHeight() -> Int {
        return StandartSection.rowHeight
    }


    func getSectionHeaderHeight() -> CGFloat {
        return StandartSection.sectionHeight
    }

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(getMyCellId(), forIndexPath: position) as! GoFurtherViewCellTableViewCell
        let teacher = list[position.row] as! SimpleUser
        cell.plainLabel.text = teacher.firstName + " " + teacher.lastName
        return cell
    }

    func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {
        if let myUser: SimpleUser = self.list[position] {
            let currentTeacher = CurrentTeacherHolder.sharedInstance
            currentTeacher.currentTeacher = myUser
            let teachController = TeacherDetailTableViewController()
            teachController.simpleUser = myUser
            controller?.pushViewController(teachController, animated: true)


        }
    }

    func getMyCellId() -> String {
        return "lecturersId"
    }

}