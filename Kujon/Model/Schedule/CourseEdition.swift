//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
//{
//    "course_id": "4018-WYK22Z",
//    "term_id": "2015",
//    "course_name": "Wstęp do studiów regionalnych"
//}

struct CourseEdition {
    let courseId: String
    let termId : String
    let courseName: String
}

extension CourseEdition:Decodable{

    static func decode(_ j: Any) throws -> CourseEdition {
        return try CourseEdition(
            courseId: j => "course_id",
                    termId: j => "term_id",
                    courseName: j => "course_name"

        )
    }

}
