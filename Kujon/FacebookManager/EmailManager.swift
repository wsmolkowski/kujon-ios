//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class EmailManager: UserLogin {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = EmailManager()

    func login(email: String ,token: String,listener: OnFacebookCredentailSaved) {
        self.userDataHolder.userLoginType = StringHolder.emailType
        self.userDataHolder.userEmail = email
        self.userDataHolder.userToken = token
        listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
    }

    func logout() {
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
    }

    func getLoginType() -> UserLoginEnum {
        return .EMAIL
    }


}