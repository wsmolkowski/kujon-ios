//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ClassTypeSection:SectionHelperProtocol {

    let classTypeCellId = "classTypeCellId"


    private var description: String! = nil
    func fillUpWithData(courseDetails: CourseDetails) {
        description = ""
        for courseGroup in courseDetails.groups {
            description.appendContentsOf(courseGroup.classType + ", numer grupy:" + String(courseGroup.groupNumber) + "\n")
        }
    }

    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: classTypeCellId)
    }

    func getSectionTitle() -> String {
        return StringHolder.classType
    }

    func getSectionSize() -> Int {
        return 1
    }

    func getRowHeight() -> Int {
        return StandartSection.rowHeight
    }


    func getSectionHeaderHeight() -> CGFloat {
        return StandartSection.sectionHeight
    }

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(classTypeCellId, forIndexPath: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = description
        return cell
    }

    func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {
        let textController = TextViewController(nibName: "TextViewController", bundle: NSBundle.mainBundle())
        textController.text = description
        textController.myTitle = getSectionTitle()
        controller?.pushViewController(textController, animated: true)
    }

}
