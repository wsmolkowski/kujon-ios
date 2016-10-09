//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


protocol OnFacebookCredentailSaved: class{
    func onFacebookCredentailSaved(isLogged:Bool)
}
class FacebookManager : UserLogin {
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
            self.userDataHolder.userLoginType = StringHolder.fbType
            listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)

        }
    }

    func getLoginType() -> UserLoginEnum {
        return .FACEBOOK
    }


    func logout(succes: LogoutSucces){
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        succes.succes()
    }

}
