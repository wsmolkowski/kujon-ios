//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class CourseMenuItem: MenuItemWithController {

    func returnTitle() -> String {
        return StringHolder.courses
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "courses-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {

            return CoursesTableViewController()
        }
    }

    func returnViewController() -> Bool {
        return true
    }



}
