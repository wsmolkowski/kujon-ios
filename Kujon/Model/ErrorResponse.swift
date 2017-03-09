//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct ErrorResponse {
    let status: String
    let message: String
    let code: Int?
}


extension ErrorResponse: Decodable {
    static func decode(_ j: Any) throws -> ErrorResponse {
        return try ErrorResponse(
                status: j => "status",
                message: j => "message",
                code: try? j => "code"
                )
    }

}
