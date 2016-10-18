//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDataHolder {

    static let sharedInstance = UserDataHolder()

    fileprivate  let LOGGED_KEY = "is_logged_key"
    fileprivate  let EMAIL_KEY = "email_key"
    fileprivate  let TOKEN_KEY = "token_key"
    fileprivate  let USOS_IMAGE_KEY = "usos_image_key"
    fileprivate  let LOGIN_TYPE_KEY = "login_type_traalalal_key"
    
    fileprivate var loadedEmail: String! = nil

    fileprivate var loadedToken: String! = nil
    fileprivate var usosImage: String! = nil
    fileprivate var loginType: String! = nil
    var usosId: String! = "DEMO"
    var usosName: String! = nil

    fileprivate var defaultsManager: UserDefaultsManager


    init() {
        defaultsManager = UserDefaultsManager(withNSUserDefaults: UserDefaults.standard)
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

    var userImage:UIImage! = nil
    var userName: String!  = nil

    fileprivate func standardGetter(_ value: inout String!, key: String) -> String! {
        if (value == nil) {
            value = self.defaultsManager.readStringFromUserDefaults(key)
        }
        return value
    }

    fileprivate func standardSetter(_ value: inout String!, newValue: String!, key: String) {
        self.defaultsManager.writeStringToUserDefaults(newValue,key: key)
        value = newValue
    }


}
