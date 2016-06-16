//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Room {
    let buldingId: String
    let buldingName: String
    let number: String
    let id: String
}


extension Room: Decodable {
    static func decode(j: AnyObject) throws -> Room {
        return try Room(
        buldingId: j => "bulding_id",
                buldingName: j => "bulding_name",
                number: j => "number",
                id: j => "id"
        )
    }

}