//
//  GoogleManager.swift
//  Kujon
//
//  Created by Dmitry Kolesnikov on 7/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class GoogleManager {
    let userDataHolder = UserDataHolder.sharedInstance

    static let sharedInstance = GoogleManager()


    func loadGoogleParams() {

        if (GIDSignIn.sharedInstance().currentUser != nil) {
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            let email = GIDSignIn.sharedInstance().currentUser.profile.email
            self.userDataHolder.userToken = accessToken
            self.userDataHolder.userEmail = email
        }

//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            let token: String = FBSDKAccessToken.currentAccessToken().tokenString;
//            print("Token : \(token) ")
//            self.userDataHolder.userToken = token
//
//        }
//
//        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).startWithCompletionHandler {
//            (connection, result, error) -> Void in
//            let strFirstName: String = (result.objectForKey("first_name") as? String)!
//            let email: String = (result.objectForKey("email") as? String)!
//            self.userDataHolder.userEmail = email
//            listener.onFacebookCredentailSaved(self.userDataHolder.loggedToUsosForCurrentEmail)
////            self.handleOpenCorrectController()
//
//        }
    }

    func logout(){
        userDataHolder.userEmail = nil
        userDataHolder.userToken = nil
    }
}
