//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct SchoolStats {
    let courseCount: Int
    let programmeCount: Int
    let staffCount: Int

}

extension SchoolStats: Decodable {
    static func decode(_ j: Any) throws -> SchoolStats {
        return try SchoolStats(
        courseCount: j => "course_count",
                programmeCount: j => "programme_count",
                staffCount: j => "staff_count"
        )
    }

}
