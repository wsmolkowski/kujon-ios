//
// Created by Wojciech Maciejewski on 02/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

enum UserLoginEnum {
    case FACEBOOK
    case GOOGLE
}

extension UserLoginEnum {
    static func getLoginType() -> UserLoginEnum {
        let userHolder = UserDataHolder.sharedInstance
        if let type = userHolder.userLoginType {

            if (type == StringHolder.googleType) {
                return .GOOGLE
            } else {
                return .FACEBOOK
            }
        }
        return .FACEBOOK
    }

    static func getUserLogin() -> UserLogin {

        let userHolder = UserDataHolder.sharedInstance
        if let type = userHolder.userLoginType {

            if (type == StringHolder.googleType) {
                return GoogleManager.sharedInstance
            } else {
                return FacebookManager.sharedInstance
            }
        }
        return FacebookManager.sharedInstance
    }
}


protocol UserLogin {
    func logout()
    func getLoginType() -> UserLoginEnum
}

extension UserLogin{
    func logoutUserData(userData: UserDataHolder){
        userData.userEmail = nil
        userData.userToken = nil
        userData.userImage = nil
        userData.userName = nil
    }
}