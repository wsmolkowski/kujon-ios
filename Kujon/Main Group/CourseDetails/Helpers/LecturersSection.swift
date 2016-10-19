//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class LecturersSection: SectionHelperProtocol {
    var list: Array<SimpleUser>! = Array()
    func fillUpWithData(_ courseDetails: CourseDetails) {
        if (courseDetails.lecturers != nil) {
            list = courseDetails.lecturers
        }
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: getMyCellId())
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

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: getMyCellId(), for: position) as! GoFurtherViewCellTableViewCell
        let teacher = list[(position as NSIndexPath).row] 
        cell.plainLabel.text = teacher.firstName + " " + teacher.lastName
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?) {
        guard position < list.count else {
            return
        }
        let myUser: SimpleUser = self.list[position]
        let currentTeacher = CurrentTeacherHolder.sharedInstance
        currentTeacher.currentTeacher = myUser
        let teachController = TeacherDetailTableViewController()
        teachController.simpleUser = myUser
        controller?.pushViewController(teachController, animated: true)
    }

    func getMyCellId() -> String {
        return "lecturersId"
    }

}
