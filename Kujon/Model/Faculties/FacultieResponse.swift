//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

struct FacultieResponse {
    let status: String
    let list: Facultie
}

extension FacultieResposne: Decodable {
    static func decode(j: AnyObject) throws -> FacultieResposne {
        return try FacultieResposne(
        status: j => "status",
                list: j => "data"
        )
    }

}
