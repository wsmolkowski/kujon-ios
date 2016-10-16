//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct LectureResponse {
    let status: String
    let data: Array<Lecture>
}


extension LectureResponse: Decodable {
    static func decode(_ j: Any) throws -> LectureResponse {
        return try LectureResponse(
        status: j => "status",
                data: j => "data"
        )
    }
}
