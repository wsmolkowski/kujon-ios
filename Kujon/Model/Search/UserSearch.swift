//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct UserSearchResponse {
    let status: String
    let data: UserSearchData

}

extension UserSearchResponse: Decodable {
    static func decode(j: AnyObject) throws -> UserSearchResponse {
        return try UserSearchResponse(
                status: j => "status",
                data: j => "data"
                )
    }
}

struct UserSearchData: Decodable {

    let items: Array<UserSearch>
    let nextPage: Bool
    static func decode(j: AnyObject) throws -> UserSearchData {
        return try UserSearchData(
                items: j => "status",
                nextPage: j => "next_page"
                )
    }

}

struct UserSearch: SearchElementProtocol, Decodable {
    let match: String
    let userId: String
    let staffStatus: String
    let studentStatus: String


    static func decode(j: AnyObject) throws -> UserSearch {
        return try UserSearch(
                match: j => "match",
                userId: j => "id",
                staffStatus: j => "staff_status",
                studentStatus: j => "student_status"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(mainController: UINavigationController) {
        var controller: UIViewController;
        if (self.staffStatus.lowercaseString == "pracownik" || self.staffStatus.lowercaseString == "nauczyciel akademicki") {
            controller = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: NSBundle.mainBundle())
            (controller as!TeacherDetailTableViewController).teacherId = self.userId
        } else if (self.studentStatus.lowercaseString == "aktywny student") {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: NSBundle.mainBundle())
            (controller as! StudentDetailsTableViewController).userId = self.userId
        } else {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: NSBundle.mainBundle())
            (controller as! StudentDetailsTableViewController).userId = self.userId
        }

        mainController.pushViewController(controller, animated: true);
    }

}

