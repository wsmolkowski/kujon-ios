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
        return  Room(
                buildingId: try? j => "building_id",
                buildingName: try? j => "building_name",
                number: try? j => "number",
                id: try? j => "id"
                )
    }

}

extension Room {
    func getRoomString() -> String {
        let st1 = self.buildingName != nil ? self.buildingName + " " : ""
        let st2 = self.number != nil ? self.number + " " : ""
        return st1 + st2
    }
}