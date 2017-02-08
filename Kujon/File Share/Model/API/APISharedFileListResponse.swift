//
//  APISharedFileResponse.swift
//  Kujon
//
//  Created by Adam on 09.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APISharedFileListResponse: Decodable {

    let status: String
    var file: APISharedFile

    static func decode(_ j: Any) throws -> APISharedFileListResponse {
        return try APISharedFileListResponse (
            status: j => "status",
            file: j => "data"
        )
    }
    
}
