//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct LecturersResponse {
    let status: String
    let data:Array<SimpleUser>
}


extension LecturersResponse: Decodable {
    static func decode(_ j: Any) throws -> LecturersResponse {
        return try LecturersResponse(
        status: j => "status",
                data: j => "data"
        )
    }
}
