//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Room {
    let buildingId: String!
    let buildingName: String!
    let number: String!
    let id: String!
}


extension Room: Decodable {
    static func decode(j: AnyObject) throws -> Room {
        return try Room(
        buildingId: try? j => "building_id",
                buildingName: try? j => "building_name",
                number: try? j => "number",
                id: try? j => "id"
        )
    }

}