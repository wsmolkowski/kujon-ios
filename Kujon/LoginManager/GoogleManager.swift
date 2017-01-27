//
//  GoogleManager.swift
//  Kujon
//
//  Created by Dmitry Kolesnikov on 7/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class GoogleManager: UserLogin, LogoutProviderDelegate {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = GoogleManager()
    var logoutProvider = ProvidersProviderImpl.sharedInstance.provideLogoutProvider()
    var logoutResult: LogoutSucces!

    func loadGoogleParams(_ listener: UserLoginDelegate) {

        if (GIDSignIn.sharedInstance().currentUser != nil) {
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.idToken
            let email = GIDSignIn.sharedInstance().currentUser.profile.email
            self.userDataHolder.userToken = accessToken
            self.userDataHolder.userEmail = email
            self.userDataHolder.userLoginType = StringHolder.googleType

            self.userDataHolder.userEmail = email
            listener.onCredentialsSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
        }

    }

    func isLoggedIn(_ logComplete:() ->Void,googleComplete:()->Void,noLogged:()->Void)  {

        if (FBSDKAccessToken.current() != nil) {
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
        return .google
    }


    func logout(_ succes: LogoutSucces) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
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

    func onErrorOccurs(_ text: String) {
        logoutResult.failed(text)
        logoutResult = nil
    }

    func unauthorized(_ text: String){
        logoutResult.failed(text)
        logoutResult = nil
    }

}
