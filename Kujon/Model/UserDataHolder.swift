//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDataHolder {
    static let sharedInstance = UserDataHolder()


    var userEmail: String! = nil
    var userToken: String! = nil
    var usosId: String! = "DEMO"

}
