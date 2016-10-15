//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct FacultieResponse {
    let status: String
    let list: Facultie
}

extension FacultieResponse: Decodable {
    static func decode(_ j: AnyObject) throws -> FacultieResponse {
        return try FacultieResponse(
        status: j => "status",
                list: j => "data"
        )
    }

}
