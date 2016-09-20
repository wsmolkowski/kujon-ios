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

    func isLoggedIn() -> Bool {
        var loggedToFB = false;
        var loggedToGoogle = false;
        var loggedViaEmail = false;

        if (FBSDKAccessToken.currentAccessToken() != nil) {
            loggedToFB = true;
        }

        if (GIDSignIn.sharedInstance().currentUser != nil) {
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            if (accessToken != nil) {
                loggedToGoogle = true;
            }
        }
        if (userDataHolder.userLoginType == StringHolder.emailType && userDataHolder.userToken != nil) {
            loggedViaEmail = true
        }
        return loggedToFB || loggedToGoogle || loggedViaEmail;
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
