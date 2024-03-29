//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct FacId {
    let id: String
    let name: String
}


extension FacId: Decodable {
    static func decode(_ j: Any) throws -> FacId {
        return try FacId(
        id: j => "fac_id",
                name: j => "name"
        )
    }

}
