//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class EmailManager: UserLogin, LogoutProviderDelegate {
    let userDataHolder = UserDataHolder.sharedInstance
    var logoutProvider = ProvidersProviderImpl.sharedInstance.provideLogoutProvider()
    static let sharedInstance = EmailManager()
    var logoutResult: LogoutSucces! = nil


    func login(_ email: String, token: String, listener: UserLoginDelegate) {
        self.userDataHolder.userLoginType = StringHolder.emailType
        self.userDataHolder.userEmail = email
        self.userDataHolder.userToken = token
        listener.onCredentialsSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
    }


    func logout(_ succes: LogoutSucces) {
        logoutResult = succes;
        logoutProvider.delegate = self
        logoutProvider.logout()
    }

    func onSuccesfullLogout() {
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        logoutResult.succes()
        logoutResult = nil
    }

    internal func onErrorOccurs(_ text: String, retry: Bool) {
        logoutResult.failed(text)
        logoutResult = nil
    }

    func unauthorized(_ text: String){
        logoutResult.failed(text)
        logoutResult = nil
    }
    

    func getLoginType() -> UserLoginEnum {
        return .email
    }


}
