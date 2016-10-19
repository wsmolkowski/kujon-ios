//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct UserSearchResponse: GetListOfSearchElements {
    let data: UserSearchData

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

extension UserSearchResponse: Decodable {
    static func decode(_ j: Any) throws -> UserSearchResponse {
        return try UserSearchResponse(
                data: j => "data"
                )
    }
}

struct UserSearchData: Decodable {

    let items: Array<UserSearch>
    let nextPage: Bool
    static func decode(_ j: Any) throws -> UserSearchData {
        return try UserSearchData(
                items: j => "items",
                nextPage: j => "next_page"
                )
    }

}

struct UserSearchSuper: Decodable {
    let userId: String
    let staffStatus: String
    let studentStatus: String
    static func decode(_ j: Any) throws -> UserSearchSuper {
        return try UserSearchSuper(
                userId: j => "id",
                staffStatus: j => "staff_status",
                studentStatus: j => "student_status"
                )
    }
}

struct UserSearch: SearchElementProtocol, Decodable {
    let match: String
    let user: UserSearchSuper

    static func decode(_ j: Any) throws -> UserSearch {
        return try UserSearch(
                match: j => "match",
                user: j => "user"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(_ mainController: UINavigationController) {
        var controller: UIViewController;
        if (self.user.staffStatus.lowercased() == "pracownik" || self.user.staffStatus.lowercased() == "nauczyciel akademicki") {
            controller = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: Bundle.main)
            (controller as! TeacherDetailTableViewController).teacherId = self.user.userId
        } else if (self.user.studentStatus.lowercased() == "aktywny student") {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: Bundle.main)
            (controller as! StudentDetailsTableViewController).userId = self.user.userId
        } else {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: Bundle.main)
            (controller as! StudentDetailsTableViewController).userId = self.user.userId
        }

        mainController.pushViewController(controller, animated: true);
    }

}

