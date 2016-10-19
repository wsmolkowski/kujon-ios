//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


protocol OnFacebookCredentailSaved: class{
    func onFacebookCredentailSaved(_ isLogged:Bool)
}

class FacebookManager : UserLogin {

    let userDataHolder = UserDataHolder.sharedInstance
    static let sharedInstance = FacebookManager()

    func loadFBParams(_ listener: OnFacebookCredentailSaved) {

        if (FBSDKAccessToken.current() != nil) {
            let token: String = FBSDKAccessToken.current().tokenString;
            print("Token : \(token) ")
            self.userDataHolder.userToken = token

        }

        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).start {
            (connection, result, error) -> Void in
            if let resultDictionary = result as? [String: AnyObject] {
                //let strFirstName: String = (resultDictionary["first_name"] as? String)!
                let email: String = resultDictionary["email"] as! String
                self.userDataHolder.userEmail = email
                self.userDataHolder.userLoginType = StringHolder.fbType
                listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
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
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        succes.succes()
    }

}
