//
// Created by Wojciech Maciejewski on 14/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct StudentProgrammeResponse {
    let status: String
    let list: Array<StudentProgramme>
}

extension StudentProgrammeResponse: Decodable {
    static func decode(_ j: Any) throws -> StudentProgrammeResponse {
        return try StudentProgrammeResponse(
        status: j => "status",
                list: j => "data"
        )
    }

}
