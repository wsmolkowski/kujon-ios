//
// Created by Wojciech Maciejewski on 09/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class ScheduleMenuItem:MenuItemWithController {
    func returnTitle() -> String {
        return StringHolder.schedule
    }

    func returnImage() -> UIImage! {
        return UIImage(named:"plan-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return CalendarViewController()}
    }

    func returnViewController() -> Bool {
        return true
    }

}
