//
// Created by Wojciech Maciejewski on 19/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct RegisterResponse {
    let data: String
    let status: String
}


extension RegisterResponse: Decodable {
    static func decode(j: AnyObject) throws -> RegisterResponse {
        return try RegisterResponse(
                data: j => "data",
                status: j => "status"
                )
    }

}