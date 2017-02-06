//
//  DriveQuery.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

let kDriveRootFolderId: String = "root"

enum DriveQuery: StringConvertible {
    case allDriveContents
    case rootFolderContents
    case contentsInFolderId(String)
    case trashed(Bool)

    internal var toString: String {
        switch self {
        case .allDriveContents:
            return ""
        case .rootFolderContents:
            return query(for: kDriveRootFolderId, in: .parents)
        case .contentsInFolderId(let folderId):
            return query(for: folderId, in: .parents)
        case .trashed(let boolValue):
            return set(boolValue.toString, for: .trashed)
        }
    }

    private func query(for value: String, in field: DriveQueryFields.Field) -> String {
        return String(format: "'%@' IN %@", value, field.rawValue)
    }

    private func set(_ value: String, for field: DriveQueryFields.Field) -> String {
        return String(format: "%@=%@", field.rawValue, value)
    }

}


extension Array where Element: StringConvertible {

    func toDriveQueryString() -> String {
        return self.map({ $0.toString }).joined(separator:" and ")
    }

}
