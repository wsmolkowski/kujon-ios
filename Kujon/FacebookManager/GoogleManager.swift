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
            self.userDataHolder.userLoginType = "GOOGLE"
        }

    }

    func logout(){
        userDataHolder.userEmail = nil
        userDataHolder.userToken = nil
    }
}
