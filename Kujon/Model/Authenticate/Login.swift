//
// Created by Wojciech Maciejewski on 20/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Login {
    let token: String
}

extension Login: Decodable {
    static func decode(j: AnyObject) throws -> Login {
        return try Login(
                token: j => "token"
                )
    }

}


struct LoginResponse {
    let data: Login
    let status: String
}


extension LoginResponse: Decodable {
    static func decode(j: AnyObject) throws -> LoginResponse {
        return try LoginResponse(
                data: j => "data",
                status: j => "status"
                )
    }

}