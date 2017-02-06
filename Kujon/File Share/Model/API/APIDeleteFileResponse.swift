//
//  APIDeleteFileResponse.swift
//  Kujon
//
//  Created by Adam on 10.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APIDeleteFileResponse: Decodable {

    let status: String
    let fileId: String

    static func decode(_ j: Any) throws -> APIDeleteFileResponse {
        return try APIDeleteFileResponse (
            status: j => "status",
            fileId: j => "data"
        )
    }
    
}
