//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

import Decodable


struct FacultySearchResponse:Decodable, GetListOfSearchElements{
    let data: FacultySearchData
    static func decode(_ j: Any) throws -> FacultySearchResponse {
        return try FacultySearchResponse(
                data: j => "data"
                )
    }

    func getList() -> Array<SearchElementProtocol> {
        let data = self.data;
        var array:Array<SearchElementProtocol>  = Array()
        for userSearch in data.items{
            array.append(userSearch)
        }
        return array;

    }

    func isThereNext() -> Bool {
        return self.data.nextPage
    }
}


struct FacultySearchData: Decodable {

    let items: Array<FacultySearch>
    let nextPage: Bool
    static func decode(_ j: Any) throws -> FacultySearchData {
        return try FacultySearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }

}
struct FacultySearch:Decodable,SearchElementProtocol {
    let facId: String
    let match: String

    static func decode(_ j: Any) throws -> FacultySearch {
        return try FacultySearch(
                facId: j => "id",
                match: j => "match"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(_ mainController: UINavigationController) {
        let faculty = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
        faculty.facultieId = self.facId
        mainController.pushViewController(faculty, animated: true)
    }

}
