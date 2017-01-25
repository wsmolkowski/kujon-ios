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

struct CourseGrade {
    let courseName: String
    let courseId: String

    let grades:Array<Grade>
    let termId:String



}
struct PreparedGrades {
    let courseName: String
    let courseId: String

    let grades: Grade
    let termId:String

}

extension PreparedGrades: SortKeyProviding {

    var sortKey: String {
        return courseName
    }
}


struct Grade{
    let valueDescription: String
    let valueSymbol: String
    let examId: Int
    let examSessionNumber: Int
    let classType: String?

    func getGrade() -> GradeEnum {
        switch (valueSymbol) {
        case "2": return GradeEnum.niedostateczny
        case "3": return GradeEnum.dostateczny
        case "4": return GradeEnum.dobry
        case "5": return GradeEnum.bardzo_DOBRY
        case "6": return GradeEnum.celujacy
        default: return GradeEnum.nieklasyfikowany
        }
    }

    func getClassType()->String{
        if(classType == nil){
            return ""
        }else {
            return self.classType!
        }
    }

}

enum GradeEnum {
    case niedostateczny, dostateczny, dobry, bardzo_DOBRY, celujacy , nieklasyfikowany
}

extension CourseGrade: Decodable {
    static func decode(_ j: Any) throws -> CourseGrade {
        return try CourseGrade(

                courseName: j => "course_name",
                courseId: j => "course_id",
                grades: j => "grades",
                termId: j => "term_id"

        )
    }

}


extension Grade: Decodable {
    static func decode(_ j: Any) throws -> Grade {
        return try Grade(
                valueDescription: j => "value_description",
                valueSymbol: j => "value_symbol",
                examId: j => "exam_id",
                examSessionNumber: j => "exam_session_number",
                classType: try? j => "class_type"

                )
    }



}
