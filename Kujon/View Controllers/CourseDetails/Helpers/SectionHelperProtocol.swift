//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
protocol SectionHelperProtocol {

    func fillUpWithData(_ courseDetails: CourseDetails)

    func registerView(_ tableView: UITableView)

    func getSectionTitle() -> String?

    func getSectionSize() -> Int

    func sectionHeaderHeight() -> CGFloat

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath)->UITableViewCell!

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?)
}
