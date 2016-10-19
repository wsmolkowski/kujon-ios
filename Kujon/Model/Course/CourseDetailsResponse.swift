//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct CourseDetailsResponse {
    let status: String
    let details: CourseDetails
}

extension CourseDetailsResponse: Decodable {
    static func decode(_ j: Any) throws -> CourseDetailsResponse {
        return try CourseDetailsResponse(
        status: j => "status",
                details: j => "data"
        )
    }

}
