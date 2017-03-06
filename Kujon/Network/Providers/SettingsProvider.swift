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
    func setOneSignalGradeNotifications(enabled: Bool)
}


protocol SettingsProviderDelegate: ErrorResponseProtocol {

    func settingsDidLoad(_ settings: Settings)
    func calendarSyncronizationSettingDidSucceed()
    func oneSignalNotificationsSettingDidSucceed()
}


class SettingsProvider: RestApiManager, SettingsProviderProtocol {

    enum SettingsEndpoint: String {
        case getSettings = "/settings"
        case postGradeNotificationsState = "/settings/event"
        case postFileNotificationsState = "/settings/eventfiles"
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
            if let data = data,
                let response = try! self?.changeJsonToResposne(data, errorR: self?.delegate),
                let settings: Settings = response.data {
                self?.userData.isCalendarSyncEnabled = settings.calendarSyncEnabled ?? false
                self?.userData.oneSignalGradeNotificationsEnabled = settings.oneSignalGradeNotificationsEnabled ?? false
                self?.userData.oneSignalFileNotificationsEnabled = settings.oneSignalFileNotificationsEnabled ?? false
                self?.userData.areSettingsLoaded = true
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
        makeHTTPAuthenticatedPostRequest({ [weak self] data in
            if let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let status = responseJSON?["status"], status as? String == "success" {
                    UserDataHolder.sharedInstance.isCalendarSyncEnabled = enabled
                    self?.delegate?.calendarSyncronizationSettingDidSucceed()
            } else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
        }, onError: { [weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })
    }

    func setOneSignalGradeNotifications(enabled: Bool) {
        let state: State = enabled ? .enabled : .disabled
        endpointURL = SettingsEndpoint.postGradeNotificationsState.rawValue + state.rawValue
        makeHTTPAuthenticatedPostRequest({ [weak self] data in

            if let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let status = responseJSON?["status"], status as? String == "success" {
                UserDataHolder.sharedInstance.oneSignalGradeNotificationsEnabled = enabled
                self?.delegate?.oneSignalNotificationsSettingDidSucceed()
            } else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
        }, onError: { [weak self] text in
            self?.delegate?.onErrorOccurs(text)
        })
    }

    func setOneSignalFileNotifications(enabled: Bool) {
        let state: State = enabled ? .enabled : .disabled
        endpointURL = SettingsEndpoint.postFileNotificationsState.rawValue + state.rawValue
        makeHTTPAuthenticatedPostRequest({ [weak self] data in

            if let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let status = responseJSON?["status"], status as? String == "success" {
                UserDataHolder.sharedInstance.oneSignalFileNotificationsEnabled = enabled
                self?.delegate?.oneSignalNotificationsSettingDidSucceed()
            } else {
                self?.delegate?.onErrorOccurs(StringHolder.errorOccures)
            }
            }, onError: { [weak self] text in
                self?.delegate?.onErrorOccurs(text)
        })
    }

    override func getMyUrl() -> String {
        return self.baseURL + endpointURL
    }
    
}
