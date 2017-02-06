//
//  DriveQueryFields.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class DriveQueryFields: StringConvertible {

    enum Field: String {
        case mimeType, id, parents, name, size, webViewLink, thumbnailLink, trashed, createdTime, modifiedTime
    }

    private var queryFields: [Field] = []

    internal static var deafultFields: String {
        let queryFields = DriveQueryFields()
        queryFields.add(queryFields: .id, .mimeType, .name, .parents, .size, .thumbnailLink, .trashed, .createdTime, .modifiedTime)
        return queryFields.toString
    }

    internal func add(queryFields:Field...) {
        self.queryFields += queryFields
    }

    internal var toString: String {
        let queries = queryFields.map({ $0.rawValue }).joined(separator:",")
        return String(format: "nextPageToken,files(%@)", queries)
    }

}
