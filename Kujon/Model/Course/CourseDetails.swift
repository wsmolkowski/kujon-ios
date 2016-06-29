//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct CourseDetails {



    let isConducted: String
    let bibliography: String
    let description: String
    let termId: String
    let facId: FacId
    let participants: Array<SimpleUser>?
    let coordinators: Array<SimpleUser>?
    let lecturers: Array<SimpleUser>?
    let homepageUrl : String
    let languageId : String
    let courseUnitsId : Array<String>
    let term: Term
    let groups : Array<CourseGroup>
    let learnignOutcomes: String
    let courseId : String
    let courseName : String
    let assessmentCriteria: String

}

extension CourseDetails:Decodable{
    static func decode(j: AnyObject) throws -> CourseDetails {
        return try CourseDetails(
            isConducted: j => "is_currently_conducted",
                    bibliography: j => "bibliography",
                    description: j => "description",
                    termId: j => "term_id",
                    facId: j => "fac_id",
                    participants: j => "participants",
                    coordinators: j => "coordinators",
                    lecturers: j => "lecturers",
                    homepageUrl: j => "homepage_url",
                    languageId: j => "lang_id",
                    courseUnitsId: j => "course_units_ids",
                    term: j => "term",
                    groups: j => "groups",
                    learnignOutcomes: j => "learning_outcomes",
                    courseId: j => "course_id",
                    courseName: j => "course_name",
                    assessmentCriteria: j => "assessment_criteria"
        )
    }

}

