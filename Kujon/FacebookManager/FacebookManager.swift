//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


protocol OnFacebookCredentailSaved{
    func onFacebookCredentailSaved(isLogged:Bool)
}
class FacebookManager {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = FacebookManager()





    func loadFBParams(listener: OnFacebookCredentailSaved) {

        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let token: String = FBSDKAccessToken.currentAccessToken().tokenString;
            print("Token : \(token) ")
            self.userDataHolder.userToken = token

        }

        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).startWithCompletionHandler {
            (connection, result, error) -> Void in
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let email: String = (result.objectForKey("email") as? String)!
            self.userDataHolder.userEmail = email
            listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
//            self.handleOpenCorrectController()

        }
        self.userDataHolder.userLoginType = "FB"
    }

    func logout(){
        userDataHolder.userEmail = nil
        userDataHolder.userToken = nil
    }
}
