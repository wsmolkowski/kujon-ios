//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class TeachersMenuItem : MenuItemWithController {

    func returnTitle() -> String {
        return StringHolder.lecturers
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "teacher-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return TeacherTableViewController()}
    }

    func returnViewController() -> Bool {
        return true
    }


}