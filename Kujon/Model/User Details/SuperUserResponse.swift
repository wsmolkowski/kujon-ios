//
// Created by Wojciech Maciejewski on 26/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct SuperUserResponse {
    let status: String
    let data: SuperUserDetails
}


extension SuperUserResponse: Decodable {
    static func decode(_ j: Any) throws -> SuperUserResponse {
        return try SuperUserResponse(
                status: j => "status",
                data: j => "data"
                )
    }
}
