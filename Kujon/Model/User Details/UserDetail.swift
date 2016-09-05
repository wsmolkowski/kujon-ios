//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct UserDetail {
    let updateTime: String?
    let createdTime: String?
    let titles: Title
    let staffStatus: String
    let userType: String?
    let sex: String
    let firstName: String
    let lastName: String
    let photoUrl: String?
    let studentProgrammes: Array<StudentProgramme>
    let id: String
    let studentNumber: String!
    let room: Room?
    let courseEditionsConducted: Array<CourseEdition>?
    let emailUrl: String!
    let studentStatus: String
    let name: String?
    let officeHours: String?
    let usosName: String?
    let homepage: String?
    let employmentPosition: Array<EmploymentPosition>?
    let hasEmail: Bool
    let usosId: String?
    let hasPhoto: Bool
    let email: String?
    let google: Account?
}

extension UserDetail: Decodable {
    static func decode(j: AnyObject) throws -> UserDetail {
        return try UserDetail(
        updateTime: try? j =>  "update_time",
                createdTime: try? j => "user_created",
                titles: j => "titles",
                staffStatus: j => "staff_status",
                userType: try? j => "user_type",
                sex: j => "sex",
                firstName: j => "first_name",
                lastName: j => "last_name",
                photoUrl: try? j => "photo_url",
                studentProgrammes: j => "student_programmes",
                id: j => "id",
                studentNumber: j => "student_number",
                room: try? j => "room",
                courseEditionsConducted: try? j => "course_editions_conducted",
                emailUrl: j => "email_url",
                studentStatus: j => "student_status",
                name: try? j => "name",
                officeHours: try? j => "office_hours",
                usosName: try? j => "usos_name",
                homepage: try? j => "homepage_url",
                employmentPosition: try? j => "employment_positions",
                hasEmail: j => "has_email",
                usosId: try? j => "usos_id",
                hasPhoto: j => "has_photo",
                email: try? j => "email",
                google: try? j => "google"
        )
    }


}

//
//extension UserDetail: Decodable {
//    static func decode(j: AnyObject) throws -> UserDetail {
//        return try UserDetail(
//        updateTime: j => "update_time",
//                createdTime: j => "user_created",
//                titles: j => "titles",
//                staffStatus: j => "staff_status",
//                userType: j => "user_type",
//                sex: j => "sex",
//                firstName: j => "first_name",
//                lastName: j => "last_name",
//                photoUrl: j => "photo_url",
//                studentProgrammes: j => "student_programmes",
//                id: j => "id",
//                studentNumber: j => "student_number",
//                room: j => "room",
//                courseEditionsConducted: j => "course_editions_conducted",
//                emailUrl: j => "email_url",
//                studentStatus: j => "student_status",
//                name: j => "name",
//                officeHours: j => "office_hours",
//                usosName: j => "usos_name",
//                homepage: j => "homepage_url",
//                employmentPosition: j => "employment_positions",
//                hasEmail: j => "has_email",
//                usosId: j => "usos_id",
//                hasPhoto: j => "has_photo",
//                email: j => "email",
//                google: j => "google"
//        )
//    }
//}