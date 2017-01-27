//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


class FacebookManager : UserLogin, LogoutProviderDelegate {

    let userDataHolder = UserDataHolder.sharedInstance
    static let sharedInstance = FacebookManager()
    var logoutProvider = ProvidersProviderImpl.sharedInstance.provideLogoutProvider()
    var logoutResult: LogoutSucces!

    func loadFBParams(_ listener: UserLoginDelegate) {

        if (FBSDKAccessToken.current() != nil) {
            let token: String = FBSDKAccessToken.current().tokenString;
            print("Token : \(token) ")
            self.userDataHolder.userToken = token
        }

        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).start {
            (connection, result, error) -> Void in
            if let resultDictionary = result as? [String: AnyObject] {
                //let strFirstName: String = (resultDictionary["first_name"] as? String)!
                if let email = resultDictionary["email"] as? String {
                    self.userDataHolder.userEmail = email
                }
                self.userDataHolder.userLoginType = StringHolder.fbType
                listener.onCredentialsSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
            }
        }
    }

    func getLoginType() -> UserLoginEnum {
        return .facebook
    }


    func logout(_ succes: LogoutSucces){
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        logoutResult = succes;
        logoutProvider.delegate = self
        logoutProvider.logout()

    }


    func onSuccesfullLogout() {
        logoutProvider.delegate = nil
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        logoutResult.succes()
        logoutResult = nil
    }

    func onErrorOccurs(_ text: String) {
        logoutResult.failed(text)
        logoutResult = nil
    }

    func unauthorized(_ text: String){
        logoutResult.failed(text)
        logoutResult = nil
    }

}
