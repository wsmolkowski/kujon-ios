//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct SchoolStats {
    let courseCount: Int?
    let programmeCount: Int?
    let staffCount: Int?

}

extension SchoolStats: Decodable {
    static func decode(_ j: Any) throws -> SchoolStats {
        return SchoolStats(
        courseCount: try? j => "course_count",
                programmeCount: try? j => "programme_count",
                staffCount: try? j => "staff_count"
        )
    }

}
