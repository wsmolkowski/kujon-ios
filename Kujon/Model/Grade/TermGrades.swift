//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct TermGrades {
    let termId: String
    let grades: Array<CourseGrade>
}

struct PreparedTermGrades {
    let termId: String
    let grades: Array<PreparedGrades>
}


extension TermGrades: Decodable {
    static func decode(j: AnyObject) throws -> TermGrades {
        return try TermGrades(
        termId: j => "term_id",
                grades: j => "courses"
        )
    }

}
