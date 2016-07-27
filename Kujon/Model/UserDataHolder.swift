//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDataHolder {

    static let sharedInstance = UserDataHolder()

    private  let LOGGED_KEY = "is_logged_key"
    private  let EMAIL_KEY = "email_key"
    private  let TOKEN_KEY = "token_key"
    private  let USOS_IMAGE_KEY = "usos_image_key"
    private  let LOGIN_TYPE_KEY = "login_type_key"
    
    private var loadedEmail: String! = nil
    private var loadedToken: String! = nil
    private var usosImage: String! = nil
    private var loginType: String! = nil
    var usosId: String! = "DEMO"

    private var defaultsManager: UserDefaultsManager


    init() {
        defaultsManager = UserDefaultsManager(withNSUserDefaults: NSUserDefaults.standardUserDefaults())
    }

    var userEmail: String! {
        get {
            return standardGetter(&loadedEmail,key: EMAIL_KEY)
        }
        set(newEmail) {
            self.standardSetter(&loadedEmail, newValue: newEmail,key: EMAIL_KEY)
        }
    }

    var userUsosImage:String!{
        get {
            return standardGetter(&usosImage,key: USOS_IMAGE_KEY)
        }
        set(newImage) {
            self.standardSetter(&usosImage, newValue: newImage,key: USOS_IMAGE_KEY)
        }
    }

    var userToken: String! {
        get {
            return standardGetter(&loadedToken,key: TOKEN_KEY)
        }
        set(newToken) {
            self.standardSetter(&loadedToken, newValue: newToken,key: TOKEN_KEY)
        }
    }

    var userLoginType: String! {
        get {
            return standardGetter(&loginType,key: LOGIN_TYPE_KEY)
        }
        set(newLoginType) {
            self.standardSetter(&loginType, newValue: newLoginType,key: LOGIN_TYPE_KEY)
        }
    }
    
    var loggedToUsosForCurrentEmail: Bool {
        get {
            if (userEmail == nil) {
                return false
            }
            return defaultsManager.readBooleanFromUserDefaults(LOGGED_KEY+userEmail)
        }
        set(value) {
            defaultsManager.writeBoolToUserDefaults(value,key: LOGGED_KEY+userEmail)
        }
    }


    private func standardGetter(inout value: String!, key: String) -> String! {
        if (value == nil) {
            value = self.defaultsManager.readStringFromUserDefaults(key)
        }
        return value
    }

    private func standardSetter(inout value: String!, newValue: String!, key: String) {
        value = newValue
        self.defaultsManager.writeStringToUserDefaults(value,key: key)
    }


}
