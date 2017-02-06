//
//  APISharedFile.swift
//  Kujon
//
//  Created by Adam on 09.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APISharedFile: Decodable {

    let fileId: String
    let shareOptions: ShareOptions

    static func decode(_ j: Any) throws -> APISharedFile {
        let sharedWithString: String = try j => "file_shared_with"
        let sharedWith = ShareOptions.SharedWith(rawValue: sharedWithString)
        let shareOptions = ShareOptions(sharedWith: sharedWith, ids: try? j => "file_shared_with_ids")
        
        return try APISharedFile (
            fileId: j => "file_id",
            shareOptions: shareOptions
        )
    }

}




