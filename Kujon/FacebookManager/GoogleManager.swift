//
//  GoogleManager.swift
//  Kujon
//
//  Created by Dmitry Kolesnikov on 7/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class GoogleManager: UserLogin {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = GoogleManager()


    func loadGoogleParams(listener: OnFacebookCredentailSaved) {

        if (GIDSignIn.sharedInstance().currentUser != nil) {
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.idToken
            let email = GIDSignIn.sharedInstance().currentUser.profile.email
            self.userDataHolder.userToken = accessToken
            self.userDataHolder.userEmail = email
            self.userDataHolder.userLoginType = StringHolder.googleType

            self.userDataHolder.userEmail = email
            listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
        }

    }

    func isLoggedIn(logComplete:() ->Void,googleComplete:()->Void,noLogged:()->Void)  {

        if (FBSDKAccessToken.currentAccessToken() != nil) {
            logComplete()
            return
        }

        if (userDataHolder.userLoginType != nil ) {
            if (userDataHolder.userLoginType == StringHolder.googleType) {
                googleComplete();
                return
            }
        }

        if(userDataHolder.userLoginType != nil){
            if (userDataHolder.userLoginType == StringHolder.emailType && userDataHolder.userToken != nil) {
                logComplete()
                return
            }
        }
        noLogged()
    }

    func getLoginType() -> UserLoginEnum {
        return .GOOGLE
    }


    func logout(succes: LogoutSucces) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
        SessionManager.clearCache()
        self.logoutUserData(userDataHolder)
        succes.succes()
    }

}
