//
// Created by Wojciech Maciejewski on 27/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Course {
//    let lecturers: Array<SimpleUser>?
//    let groups: Array<CourseGroup>?
//    let coordinators: Array<SimpleUser>?
//    let participants: Array<SimpleUser>?
    let termId : String
    let courseName: String
    let courseId : String
}


extension Course:Decodable{

    static func decode(j: AnyObject) throws -> Course {
        return try Course(
//            lecturers: try? j => "lecturers",
//                    groups: try? j => "groups",
//                    coordinators: try? j => "coordinators",
//                    participants: try? j => "participants",
                    termId: j => "term_id",
                    courseName: j => "course_name",
                    courseId: j => "course_id"
        )
    }

}
