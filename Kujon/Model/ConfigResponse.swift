//
// Created by Wojciech Maciejewski on 10/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Config {
    let apiUrl: String
    let userLogged: Bool
    let usosPaired: Bool
    let usosWorks: Bool
}

extension Config: Decodable {
    static func decode(_ j: Any) throws -> Config {
        return try Config(
                apiUrl: j => "API_URL",
                userLogged: j => "USER_LOGGED",
                usosPaired: j => "USOS_PAIRED",
                usosWorks: j => "USOS_WORKS"
                )
    }

}

struct ConfigResponse {
    let data: Config
}

extension ConfigResponse: Decodable {
    static func decode(_ j: Any) throws -> ConfigResponse {
        return try ConfigResponse(
                data: j => "data"
                )
    }

}
