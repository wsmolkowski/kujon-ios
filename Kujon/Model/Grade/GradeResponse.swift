//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct GradeResponse {
    let status: String
    let data: Array<TermGrades>
}


extension GradeResponse: Decodable {
    static func decode(_ j: Any) throws -> GradeResponse {
        return try GradeResponse(
        status: j => "status",
                data: j => "data"
        )
    }
}
