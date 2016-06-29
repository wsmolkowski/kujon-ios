//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
protocol SectionHelperProtocol {

    func fillUpWithData(courseDetails: CourseDetails)

    func registerView(tableView: UITableView)

    func getSectionTitle() -> String

    func getSectionSize() -> Int

    func getRowSize() -> Int

    func getSectionHeaderHeight() -> Int

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath)->UITableViewCell

    func reactOnSectionClick(position: Int, withController controller: UINavigationController)
}
