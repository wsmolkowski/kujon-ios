//
// Created by Wojciech Maciejewski on 02/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

enum UserLoginEnum {
    case FACEBOOK
    case GOOGLE
    case EMAIL
}

extension UserLoginEnum {
    static func getLoginType() -> UserLoginEnum {
        let userHolder = UserDataHolder.sharedInstance
        if let type = userHolder.userLoginType {

            if (type == StringHolder.googleType) {
                return .GOOGLE
            } else if (type == StringHolder.fbType) {
                return .FACEBOOK
            }else{
                return .EMAIL
            }
        }
        return .FACEBOOK
    }

    static func getUserLogin() -> UserLogin {

        let userHolder = UserDataHolder.sharedInstance
        if let type = userHolder.userLoginType {

            if (type == StringHolder.googleType) {
                return GoogleManager.sharedInstance
            } else if (type == StringHolder.fbType) {
                return FacebookManager.sharedInstance
            }else{
                return EmailManager.sharedInstance
            }
        }
        return FacebookManager.sharedInstance
    }
}

protocol LogoutSucces{
    func succes();
    func failed(text: String);
}

protocol UserLogin {
    func logout(succes: LogoutSucces)
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