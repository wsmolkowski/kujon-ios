//
// Created by Wojciech Maciejewski on 11/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//{
//    "value_symbol": "2",
//    "course_name": "Programowanie obiektowe",
//    "value_description": "niedostateczny",
//    "exam_id": 250755,
//    "course_id": "1000-212bPO",
//    "term_id": "2011L",
//    "exam_session_number": 1,
//    "class_type": "UNKNOWN"
//}

struct Grade {
    let valueSymbol: String
    let courseName: String
    let valueDescription: String
    let examId: Int
    let courseId: String
    let termId: String
    let examSessionNumber: Int
    let classType: String


    func getGrade() -> GradeEnum {
        switch (valueSymbol) {
        case "2": return GradeEnum.NIEDOSTATECZNY
        case "3": return GradeEnum.DOSTATECZNY
        case "4": return GradeEnum.DOBRY
        case "5": return GradeEnum.BARDZO_DOBRY
        case "6": return GradeEnum.CELUJACY
        default: return GradeEnum.NIEKLASYFIKOWANY
        }
    }

}

enum GradeEnum {
    case NIEDOSTATECZNY, DOSTATECZNY, DOBRY, BARDZO_DOBRY, CELUJACY , NIEKLASYFIKOWANY
}

extension Grade: Decodable {
    static func decode(j: AnyObject) throws -> Grade {
        return try Grade(
        valueSymbol: j => "value_symbol",
                courseName: j => "course_name",
                valueDescription: j => "value_description",
                examId: j => "exam_id",
                courseId: j => "course_id",
                termId: j => "term_id",
                examSessionNumber: j => "exam_session_number",
                classType: j => "class_type"
        )
    }

}