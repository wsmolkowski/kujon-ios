//
// Created by Wojciech Maciejewski on 02/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

enum UserLoginEnum {
    case facebook
    case google
    case email
}

extension UserLoginEnum {

    static func getLoginType() -> UserLoginEnum {
        let userHolder = UserDataHolder.sharedInstance
        if let type = userHolder.userLoginType {

            if (type == StringHolder.googleType) {
                return .google
            } else if (type == StringHolder.fbType) {
                return .facebook
            }else{
                return .email
            }
        }
        return .facebook
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
    func failed(_ text: String);
}

protocol UserLogin {
    func logout(_ succes: LogoutSucces)
    func getLoginType() -> UserLoginEnum
}

extension UserLogin{

    func logoutUserData(_ userData: UserDataHolder){
        userData.userEmail = nil
        userData.userToken = nil
        userData.userImage = nil
        userData.userName = nil
        UserDataHolder.sharedInstance.didSetUpInitialConfiguration = false
    }
}
