//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//"lecturers": [
//{
//"last_name": "G\u00f3ralowski",
//"first_name": "Marek",
//"titles": {
//"after": null,
//"before": "dr"
//},
//"id": "1"
//}
//],
//"course_name": "Systemy rozproszone",
//"name": "Systemy rozproszone - Seminarium magisterskie",
//"start_time": "2016-06-02 12:15:00",
//"group_number": 1,
//"room_number": "4070",
//"end_time": "2016-06-02 14:00:00",
//"course_id": "1000-2D97SR",
//"type": "zaj\u0119cia",
//"building_name": "Wydzia\u0142 Matematyki, Informatyki i Mechaniki - Budynek Dydaktyczny"

struct Lecture {
    let lecturers: Array<Lecturer>
    let courseName: String
    let name: String
    let startTime: String
    let endTime: String
    let groupNumber: Int
    let roomNumber: String
    let courseId: String
    let type: String
    let buldingName: String

}

extension Lecture: Decodable {
    static func decode(j: AnyObject) throws -> Lecture {
        return try Lecture(
        lecturers: j => "lecturers",
                courseName: j => "course_name",
                name: j => "name",
                startTime: j => "start_time",
                endTime: j => "end_time",
                groupNumber: j => "group_number",
                roomNumber: j => "room_number",
                courseId: j => "course_id",
                type: j => "type",
                buldingName: j => "building_name"
        )
    }

}