//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct CourseSearchResponse: GetListOfSearchElements {
    let data: CourseSearchData


    func getList() -> Array<SearchElementProtocol> {
        let data = self.data;
        var array:Array<SearchElementProtocol>  = Array()
        for userSearch in data.items{
            array.append(userSearch)
        }
        return array
    }


    func isThereNext() -> Bool {
        return self.data.nextPage
    }


}

extension CourseSearchResponse: Decodable {
    static func decode(_ j: Any) throws -> CourseSearchResponse {
        return try CourseSearchResponse(
                data: j => "data"
                )
    }
}

struct CourseSearchData: Decodable {

    let items: Array<CourseSearch>
    let nextPage: Bool
    static func decode(_ j: Any) throws -> CourseSearchData {
        return try CourseSearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }

}


struct CourseSearch: SearchElementProtocol,Decodable {
    let courseId: String
    let match: String

    static func decode(_ j: Any) throws -> CourseSearch {
        return try CourseSearch(
                courseId: j => "course_id",
                match: j => "match"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(_ mainController: UINavigationController) {
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.courseId = self.courseId
        mainController.pushViewController(courseDetails, animated: true)
    }

}


