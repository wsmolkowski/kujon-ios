//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//"after": null,
//"before": null

struct Title {
    let after: String!
    let before: String!
}

extension Title: Decodable {
    static func decode(_ j: Any) throws -> Title {
        return try Title(
                 after:j => "after",
                before: j => "before"
        )
    }
}
