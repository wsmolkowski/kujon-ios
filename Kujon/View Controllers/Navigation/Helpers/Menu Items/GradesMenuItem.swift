//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class GradesMenuItem:MenuItemWithController {


    func returnTitle() -> String {
        return StringHolder.grades
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "grades-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return { return GradesTableViewController() }
    }

    func returnViewController() -> Bool {
        return true
    }

}
