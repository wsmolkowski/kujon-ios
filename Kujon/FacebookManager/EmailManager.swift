//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class EmailManager: UserLogin {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = EmailManager()

    func login() {
        self.userDataHolder.userLoginType = StringHolder.emailType
    }

    func logout() {
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
    }

    func getLoginType() -> UserLoginEnum {
        return .EMAIL
    }


}