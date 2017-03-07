//
//  SettingsResponse.swift
//  Kujon
//
//  Created by Adam on 25.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Settings {
    let oneSignalGradeNotificationsEnabled: Bool?
    let oneSignalFileNotificationsEnabled: Bool?
    let calendarSyncEnabled: Bool?
}

extension Settings: Decodable {
    static func decode(_ j: Any) throws -> Settings {
        return Settings(
            oneSignalGradeNotificationsEnabled: try? j => "event_enable",
            oneSignalFileNotificationsEnabled: try? j => "event_files_enable",
            calendarSyncEnabled: try? j => "google_callendar_enable"
        )
    }

}

struct SettingsResponse {
    let data: Settings?
}

extension SettingsResponse: Decodable {
    static func decode(_ j: Any) throws -> SettingsResponse {
        return SettingsResponse (
            data: try? j => "data"
        )
    }

}
