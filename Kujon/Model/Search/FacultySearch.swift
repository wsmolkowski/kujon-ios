//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

import Decodable


struct FacultySearchResponse:Decodable{
    let data: CourseSearchData
    static func decode(j: AnyObject) throws -> FacultySearchResponse {
        return try FacultySearchResponse(
                data: j => "data"
                )
    }
}


struct FacultySearchData: Decodable {

    let items: Array<FacultySearch>
    let nextPage: Bool
    static func decode(j: AnyObject) throws -> FacultySearchData {
        return try FacultySearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }

}
struct FacultySearch:Decodable {
    let facId: String
    let match: String

    static func decode(j: AnyObject) throws -> FacultySearch {
        return try FacultySearch(
                facId: j => "id",
                match: j => "match"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(mainController: UINavigationController) {
        let faculty = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: NSBundle.mainBundle())
        faculty.facultieId = self.facId
        mainController.pushViewController(faculty, animated: true)
    }

}
