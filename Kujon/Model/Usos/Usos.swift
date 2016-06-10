//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Usos {
    let name: String
    let certificate: Bool
    let usosId: String
    let image: String
}

extension Usos: Decodable {
    static func decode(j: AnyObject) throws -> Usos {
        return try Usos(
        name: j => "name",
                certificate: j => "validate_ssl_certificate",
                usosId: j => "usos_id",
                image: j => "logo"
        )
    }
}