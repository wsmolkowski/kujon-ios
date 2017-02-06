//
//  APIUploadedFile.swift
//  Kujon
//
//  Created by Adam on 03.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APIUploadedFile: Decodable {

    let fileId: String
    let fileName: String
    let shareOptions: ShareOptions

    static func decode(_ j: Any) throws -> APIUploadedFile {
        let sharedWithString: String = try j => "file_shared_with"
        let sharedWith = ShareOptions.SharedWith(rawValue: sharedWithString)
        let shareOptions = ShareOptions(sharedWith: sharedWith, ids: try? j => "file_shared_with_ids")

        return try APIUploadedFile (
            fileId: j => "file_id",
            fileName: j => "file_name",
            shareOptions: shareOptions
        )
    }
    
}
