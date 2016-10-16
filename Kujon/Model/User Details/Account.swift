//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Account {
    let pictureUrl: String
    let name: String
    let email: String
}

extension Account: Decodable {
    static func decode(_ j: Any) throws -> Account {
        return try Account(
                pictureUrl: j => "picture",
                name: j => "name",
                email: j => "email"
        )
    }
}
