//
// Created by Wojciech Maciejewski on 09/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class MenuItemsHolder {

    static let sharedInstance = MenuItemsHolder()


    let upperMenuItems: Array<MenuItemWithController> = [UserMenuItem(),
                                                         ScheduleMenuItem(),
                                                         LectureMenuItem(),
                                                         GradesMenuItem(),
                                                         TeachersMenuItem()]

    let lowerMnuItems: Array<MenuItemWithController> = [SettingsMenuItem(),SendOpinionMenuItem(),ShareMenuItem()]
}
