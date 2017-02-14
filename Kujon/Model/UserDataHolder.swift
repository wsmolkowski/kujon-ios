//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserDataHolder {

    static let sharedInstance = UserDataHolder()

    private  let LOGGED_KEY = "is_logged_key"
    private  let EMAIL_KEY = "email_key"
    private  let EMAIL_REMEMBERED_KEY = "email_remembered_key"
    private  let TOKEN_KEY = "token_key"
    private  let USOS_IMAGE_KEY = "usos_image_key"
    private  let LOGIN_TYPE_KEY = "login_type_traalalal_key"
    private  let CALENDAR_SYNC_KEY = "calendar_sync_key"
    private let PUSH_NOTIFIACTIONS_KEY = "push_notifications_key"
    
    private var loadedEmail: String! = nil

    private var loadedToken: String! = nil
    private var usosImage: String! = nil
    private var loginType: String! = nil
    private var calendarSync: Bool = false

    var usosId: String! = "DEMO"
    var usosName: String! = nil

    private var defaultsManager: UserDefaultsManager


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

    var userEmailRemembered: String! {
        get {
            return standardGetter(&loadedEmail,key: EMAIL_REMEMBERED_KEY)
        }
        set(newEmail) {
            self.standardSetter(&loadedEmail, newValue: newEmail,key: EMAIL_REMEMBERED_KEY)
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

    var isCalendarSyncEnabled: Bool {
        get {
            if (userEmail == nil) {
                return false
            }
            return defaultsManager.readBooleanFromUserDefaults(CALENDAR_SYNC_KEY)
        }
        set(value) {
            defaultsManager.writeBoolToUserDefaults(value,key:CALENDAR_SYNC_KEY)
        }
    }

    var shouldSyncCalendar: Bool {
            return isCalendarSyncEnabled && UserLoginEnum.getLoginType() == .google
    }

    var oneSignalNotificationsEnabled: Bool {
        get {
            if (userEmail == nil) {
                return false
            }
            return defaultsManager.readBooleanFromUserDefaults(PUSH_NOTIFIACTIONS_KEY)
        }
        set(value) {
            defaultsManager.writeBoolToUserDefaults(value,key:PUSH_NOTIFIACTIONS_KEY)
        }
    }

    var isConfigLoaded: Bool = false
    var areSettingsLoaded: Bool = false
    var isNotificationPending: Bool = false


    var userImage:UIImage! = nil
    var userName: String!  = nil

    private func standardGetter(_ value: inout String!, key: String) -> String! {
        if (value == nil) {
            value = self.defaultsManager.readStringFromUserDefaults(key)
        }
        return value
    }

    private func standardSetter(_ value: inout String!, newValue: String!, key: String) {
        self.defaultsManager.writeStringToUserDefaults(newValue,key: key)
        value = newValue
    }


    func userNameComponents() -> (firstName: String, lastName: String) {
        let space = " "
        var userNameComponents: [String] = []

        guard let userName = UserDataHolder.sharedInstance.userName else {
            return (firstName: "", lastName: "")
        }

        if userName.contains(space) {
            userNameComponents = userName.components(separatedBy: space)
            return (firstName: userNameComponents.first!, lastName: userNameComponents.last!)
        }

        return (firstName: userName, lastName: "")
    }

}
