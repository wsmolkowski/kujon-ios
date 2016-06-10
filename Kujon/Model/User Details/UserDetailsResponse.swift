//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct UserDetailsResponse {
    let status: String
    let data: UserDetail
}


extension UserDetailsResponse: Decodable {
    static func decode(j: AnyObject) throws -> UserDetailsResponse {
        return try UserDetailsResponse(
                status: j => "status",
                data: j => "data"
        )
    }
}