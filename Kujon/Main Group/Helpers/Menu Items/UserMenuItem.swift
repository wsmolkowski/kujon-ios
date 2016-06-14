//
// Created by Wojciech Maciejewski on 09/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class UserMenuItem : MenuItemWithController{

    func returnTitle() -> String {
        return "User"
    }

    func returnImage() -> UIImage! {
        return UIImage(named:"")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return { return UserTableViewController()}
    }


}
