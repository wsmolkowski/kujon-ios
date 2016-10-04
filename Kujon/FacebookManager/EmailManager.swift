//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class EmailManager: UserLogin, LogoutProviderDelegate {
    let userDataHolder = UserDataHolder.sharedInstance
    var logoutProvider = ProvidersProviderImpl.sharedInstance.provideLogoutProvider()
    static let sharedInstance = EmailManager()

    func login(email: String, token: String, listener: OnFacebookCredentailSaved) {
        self.userDataHolder.userLoginType = StringHolder.emailType
        self.userDataHolder.userEmail = email
        self.userDataHolder.userToken = token
        listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
    }

    var suc: LogoutSucces! = nil
    func logout(succes: LogoutSucces) {
        suc = succes;
        logoutProvider.delegate = self

        logoutProvider.logout()
    }



    func onSuccesfullLogout() {
        logoutProvider.delegate = nil
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        suc.succes()
        suc = nil
    }

    func onErrorOccurs(text: String) {
        suc.failed(text)
        suc = nil
    }

    func unauthorized(text: String){
        suc.failed(text)
        suc = nil
    }
    


    func getLoginType() -> UserLoginEnum {
        return .EMAIL
    }


}