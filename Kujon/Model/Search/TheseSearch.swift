//
// Created by Wojciech Maciejewski on 09/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct TheseSearchResponse: Decodable, GetListOfSearchElements {
    let data: TheseSearchData
    static func decode(_ j: Any) throws -> TheseSearchResponse {
        return try TheseSearchResponse(
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

struct TheseSearchData: Decodable {
    let items: Array<TheseSearch>
    let nextPage: Bool


    static func decode(_ j: Any) throws -> TheseSearchData {
        return try TheseSearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }
}

struct TheseSearch: Decodable, SearchElementProtocol {
    let thesis: ThesisSearchInside
    let match: String

    static func decode(_ json: Any) throws -> TheseSearch {
        return try TheseSearch(
                thesis: json => "thesis",
                match: json => "match"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(_ mainController: UINavigationController) {
        let thesisDetailController = ThesisDetailTableViewController()
        thesisDetailController.thesis = thesis
        mainController.pushViewController(thesisDetailController, animated: true)
    }

}

struct ThesisSearchInside: Decodable {
    let id: String
    let title: String
    let type: String
    let authors: Array<SimpleUser>?
    let supervisors: Array<SimpleUser>?
    let faculty: FacultyShort?

    static func decode(_ j: Any) throws -> ThesisSearchInside {
        return try ThesisSearchInside(
                id: j => "id",
                title: j => "title",
                type: Thesis.mapThesisType(j => "type"),
                authors: try? j => "authors",
                supervisors: try? j => "supervisors",
                faculty: try? j => "faculty")
    }

}




