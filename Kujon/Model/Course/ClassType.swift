//
// Created by Wojciech Maciejewski on 08/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct ClassType {
    let en: String
    let pl: String
}


extension ClassType: Decodable {
    static func decode(_ json: Any) throws -> ClassType {
        return try ClassType(
        en: json => "en",
                pl: json => "pl"
        )
    }

}
