//
//  SettingsProvider.swift
//  Kujon
//
//  Created by Adam on 25.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

protocol SettingsProviderProtocol: JsonProviderProtocol {

    associatedtype T = SettingsResponse
    func loadSettings()
    func setCalendarSyncronization(enabled: Bool)
    func setPushNotifications(enabled: Bool)
}


protocol SettingsProviderDelegate: ErrorResponseProtocol {

    func settingsDidLoad(_ settings: Settings)
    func calendarSyncronizationSettingDidSucceed()
    func pushNotificationsSettingDidSucceed()
}


class SettingsProvider: RestApiManager, SettingsProviderProtocol {

    enum SettingsEndpoint: String {
        case getSettings = "/settings"
        case postPushNotificationsState = "/settings/event"
        case postCalendarSync = "/settings/googlecalendar"
    }

    enum State: String {
        case enabled = "/enable"
        case disabled = "/disable"
    }

    var endpointURL: String = SettingsEndpoint.getSettings.rawValue
    weak var delegate: SettingsProviderDelegate?
    let userData = UserDataHolder.sharedInstance

    func loadSettings() {
        endpointURL = SettingsEndpoint.getSettings.rawValue
        makeHTTPAuthenticatedGetRequest({ [weak self] data in
            if let response = try! self?.changeJsonToResposne(data, errorR: self?.delegate),
                let settings: Settings = response.data {
                self?.userData.isCalendarSyncEnabled = settings.calendarSyncEnabled ?? false
                self?.userData.pushNotificationsEnabled = settings.pushNotificationsEnabled ?? false
                self?.userData.areSettingsLoaded = true
                if self?.userData.pushNotificationsEnabled != NotificationsManager.pushNotificationsEnabled() {
                    self?.setPushNotifications(enabled: NotificationsManager.pushNotificationsEnabled())
                }
                self?.delegate?.settingsDidLoad(settings)
            } else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
        }, onError: { [weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })
    }

    func setCalendarSyncronization(enabled: Bool) {
        let state: State = enabled ? .enabled : .disabled
        endpointURL = SettingsEndpoint.postCalendarSync.rawValue + state.rawValue
        makeHTTPAuthenticatedPostRequest({ data in
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                responseJSON?["status"] == "success" {
                UserDataHolder.sharedInstance.isCalendarSyncEnabled = enabled
                self.delegate?.calendarSyncronizationSettingDidSucceed()
            } else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
        }, onError: { text in
            self.delegate?.onErrorOccurs(text)
        })
    }

    func setPushNotifications(enabled: Bool) {
        let state: State = enabled ? .enabled : .disabled
        endpointURL = SettingsEndpoint.postPushNotificationsState.rawValue + state.rawValue
        makeHTTPAuthenticatedPostRequest({ data in
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String],
                responseJSON?["status"] == "success" {
                UserDataHolder.sharedInstance.pushNotificationsEnabled = enabled
                self.delegate?.pushNotificationsSettingDidSucceed()
            } else {
                self.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
        }, onError: { text in
            self.delegate?.onErrorOccurs(text)
        })
    }

    override func getMyUrl() -> String {
        return self.baseURL + endpointURL
    }
    
}
