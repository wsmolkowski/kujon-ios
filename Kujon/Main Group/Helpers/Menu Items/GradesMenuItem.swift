//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class GradesMenuItem:MenuItemWithController {


    func returnTitle() -> String {
        return "Oceny"
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "grades-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return { return GradesViewController() }
    }

}
