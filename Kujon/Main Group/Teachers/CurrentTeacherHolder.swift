//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CurrentTeacherHolder {
    static let sharedInstance = CurrentTeacherHolder()

    var currentTeacher:SimpleUser! = nil
}
