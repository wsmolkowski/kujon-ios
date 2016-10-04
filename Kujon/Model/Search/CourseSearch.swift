//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct CourseSearchResponse {
    let status: String
    let data: CourseSearchData

}

extension CourseSearchResponse: Decodable {
    static func decode(j: AnyObject) throws -> CourseSearchResponse {
        return try CourseSearchResponse(
                status: j => "status",
                data: j => "data"
                )
    }
}

struct CourseSearchData: Decodable {

    let items: Array<CourseSearch>
    let nextPage: Bool
    static func decode(j: AnyObject) throws -> CourseSearchData {
        return try CourseSearchData(
                items: j => "status",
                nextPage: j => "next_page"
                )
    }

}


struct CourseSearch: SearchElementProtocol,Decodable {
    let courseId: String
    let match: String

    static func decode(j: AnyObject) throws -> CourseSearch {
        return try CourseSearch(
                courseId: j => "course_id",
                match: j => "match"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(mainController: UINavigationController) {
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: NSBundle.mainBundle())
        courseDetails.courseId = self.courseId
        mainController.pushViewController(courseDetails, animated: true)
    }

}


