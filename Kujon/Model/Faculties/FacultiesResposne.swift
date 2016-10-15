//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct FacultiesResposne {
    let status: String
    let list: Array<Facultie>
}

extension FacultiesResposne: Decodable {
    static func decode(_ j: Any) throws -> FacultiesResposne {
        return try FacultiesResposne(
        status: j => "status",
                list: j => "data"
        )
    }

}
