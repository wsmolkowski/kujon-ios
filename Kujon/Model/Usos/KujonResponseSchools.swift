//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct KujonResponseSchools {
    let status: String
    let data: Array<Usos>
}


extension KujonResponseSchools: Decodable {
    static func decode(_ j: Any) throws -> KujonResponseSchools {
        return try KujonResponseSchools(
        status: j => "status",
        data: j => "data"
        )
    }
}
