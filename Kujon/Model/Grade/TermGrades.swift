//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct TermGrades {
    let termId: String
    let grades: Array<CourseGrade>
    let averageGrade: String?

}

extension TermGrades: Decodable {
    static func decode(_ j: Any) throws -> TermGrades {
        return try TermGrades(
            termId: j => "term_id",
            grades: j => "courses",
            averageGrade: try? j => "avr_grades")
    }
    
}


struct PreparedTermGrades {
    let termId: String
    let grades: Array<PreparedGrades>
    let averageGrade: String?

    var averageGradeDescriptive: String {
        if let averageGrade = averageGrade {
            return averageGrade

        }
        return StringHolder.none_lowercase
    }
}

extension PreparedTermGrades: SortKeyProviding {

    var sortKey: String {
        return termId
    }

}


