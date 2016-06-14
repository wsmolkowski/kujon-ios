//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct FacultieResposne {
    let status: String
    let list: Array<Facultie>
}

extension FacultieResposne: Decodable {
    static func decode(j: AnyObject) throws -> FacultieResposne {
        return try FacultieResposne(
        status: j => "status",
                list: j => "data"
        )
    }

}
