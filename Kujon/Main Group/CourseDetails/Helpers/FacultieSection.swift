//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FacultieSection: SectionHelperProtocol {


    func fillUpWithData(courseDetails: CourseDetails) {
    }

    func registerView(tableView: UITableView) {
    }

    func getSectionTitle() -> String {
        return ""
    }

    func getSectionSize() -> Int {
        return 0
    }

    func getRowSize() -> Int {
        return 0
    }

    func getSectionHeaderHeight() -> Int {
        return 0
    }

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        return nil
    }

    func reactOnSectionClick(position: Int, withController controller: UINavigationController) {
    }

}
