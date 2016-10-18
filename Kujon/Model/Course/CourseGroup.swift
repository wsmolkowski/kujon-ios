//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct CourseGroup {
    let classType : String
    let courseUnitId : Int
    let groupNumber : Int
}

extension CourseGroup: Decodable{
    static func decode(_ j: Any) throws -> CourseGroup {
        return try CourseGroup(
            classType: j => "class_type",
                    courseUnitId: j => "course_unit_id",
                    groupNumber: j => "group_number"

        )
    }

}
