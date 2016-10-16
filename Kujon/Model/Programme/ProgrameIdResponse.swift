//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct ProgrameIdResponse {
    let status: String
    let singleProgramme: ProgrammeWithDifferentId
}

extension ProgrameIdResponse: Decodable {
    static func decode(_ j: Any) throws -> ProgrameIdResponse {
        return try ProgrameIdResponse(
                status: j => "status",
                singleProgramme: j => "data"
                )
    }

}
