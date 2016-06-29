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

extension FacultieResponse: Decodable {
    static func decode(j: AnyObject) throws -> FacultieResponse {
        return try FacultieResponse(
        status: j => "status",
                details: j => "data"
        )
    }

}
