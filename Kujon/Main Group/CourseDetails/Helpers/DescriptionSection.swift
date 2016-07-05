//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class DescriptionSection: SectionHelperProtocol {
    let descriptionCellId="descCellId"


    private var description:String! = nil
    func fillUpWithData(courseDetails: CourseDetails) {
        description  = courseDetails.description
    }

    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellId)
    }

    func getSectionTitle() -> String {
        return "Opis"
    }

    func getSectionSize() -> Int {
        return 1
    }

    func getRowHeight() -> Int {
        return 48
    }


    func getSectionHeaderHeight() -> CGFloat {
        return 48
    }

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(descriptionCellId, forIndexPath: position) as! GoFurtherViewCellTableViewCell
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