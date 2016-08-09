//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class SettingsMenuItem: MenuItemWithController {
    func returnTitle() -> String {
        return StringHolder.settings
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "settings-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return SettingsViewController()}
    }

    func returnViewController() -> Bool {
        return true
    }

}
