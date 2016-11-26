//
//  NotificationsManager.swift
//  Kujon
//
//  Created by Adam on 23.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation


class NotificationsManager {

    static func pushNotificationsEnabled() -> Bool {
        return UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
    }

    static func openAppSettings() {
          UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }




}
