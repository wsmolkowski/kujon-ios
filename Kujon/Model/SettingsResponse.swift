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
    let eventsEnabled: Bool?
    let calendarSyncEnabled: Bool?
}

extension Settings: Decodable {
    static func decode(_ j: Any) throws -> Settings {
        return Settings(
            eventsEnabled: try? j => "event_enable",
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
