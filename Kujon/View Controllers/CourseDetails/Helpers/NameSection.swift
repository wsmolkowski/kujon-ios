//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class NameSection: SectionHelperProtocol {


    var titleString:String! = nil;
    var id :String! = nil;
    var language:String! = nil
    var isOn: String! = nil
    let NameCellId = "nameCellIdtralalala"

    func fillUpWithData(_ courseDetails: CourseDetails) {
        titleString = courseDetails.courseName
        id = courseDetails.courseId
        if(courseDetails.languageId != nil){

            language = courseDetails.languageId
        }else {
            language = ""
        }
        isOn = courseDetails.isConducted
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "CourseNameTableViewCell", bundle: nil), forCellReuseIdentifier: NameCellId)
    }

    func getSectionTitle() -> String? {
        return ""
    }

    func getSectionSize() -> Int {
        return 1
    }

    func sectionHeaderHeight() -> CGFloat {
        return 0
    }

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: NameCellId, for: position) as! CourseNameTableViewCell
        cell.nameLabel.text = titleString
        cell.detailLabel.text = "id: " + id + ", język: " + language + ", prowadzony: " + isOn
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?, setDelegate delegate: AnyObject?) {
    }

    func updateState(isFolded: Bool) {
        // do nothing
    }

}
