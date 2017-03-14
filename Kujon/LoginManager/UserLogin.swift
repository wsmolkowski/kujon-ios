//
// Created by Wojciech Maciejewski on 02/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol UserLoginDelegate: class {
    func onCredentialsSaved(_ isLogged:Bool)
}

enum UserLoginEnum: String {
    case facebook = "FACEBOOK"
    case google = "GOOGLE"
    case email = "EMAIL"
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
        UserDataHolder.sharedInstance.isConfigLoaded = false
        UserDataHolder.sharedInstance.areSettingsLoaded = false
    }
}
