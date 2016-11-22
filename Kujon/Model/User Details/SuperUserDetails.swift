//
// Created by Wojciech Maciejewski on 26/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct SuperUserDetails {
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
    let theses: Array<Thesis>?
    let employmentPosition: Array<EmploymentPosition>?
    let hasEmail: Bool
    let usosId: String?
    let email: String?
    let google: Account?
    let programmes:Array<StudentProgramme>
    let terms: Array<Term>
    let faculties:Array<Facultie>
    let averageGrade:String?

    var averageGradeDescriptive: String {
        if let averageGrade = averageGrade {
            return averageGrade

        }
        return StringHolder.none_lowercase
    }
}

extension SuperUserDetails:Decodable{
    static func decode(_ j: Any) throws -> SuperUserDetails {
        return try SuperUserDetails(
            updateTime: try? j => "update_time",
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
                theses: try? j => "theses",
                employmentPosition: try? j => "employment_positions",
                hasEmail: j => "has_email",
                usosId: try? j => "usos_id",
                email: try? j => "email",
                google: try? j => "google",
                programmes: j => "programmes",
                terms: j => "terms",
                faculties: j => "faculties",
                averageGrade: try? j => "avr_grades")
    }

}
