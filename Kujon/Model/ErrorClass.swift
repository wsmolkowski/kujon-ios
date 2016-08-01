//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct ErrorClass {
    let status: String
    let message: String
    let code: String?
}


extension ErrorClass: Decodable {
    static func decode(j: AnyObject) throws -> ErrorClass {
        return try ErrorClass(
                status: j => "status",
                message: j => "message",
                code: j => "code"
                )
    }

}
