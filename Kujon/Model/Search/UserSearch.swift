//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct UserSearchResponse {
    let data: UserSearchData

}

extension UserSearchResponse: Decodable {
    static func decode(j: AnyObject) throws -> UserSearchResponse {
        return try UserSearchResponse(
                data: j => "data"
                )
    }
}

struct UserSearchData: Decodable {

    let items: Array<UserSearch>
    let nextPage: Bool
    static func decode(j: AnyObject) throws -> UserSearchData {
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
    static func decode(j: AnyObject) throws -> UserSearchSuper {
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

    static func decode(j: AnyObject) throws -> UserSearch {
        return try UserSearch(
                match: j => "match",
                user: j => "user"
                )
    }

    func getTitle() -> String {
        return self.match
    }

    func reactOnClick(mainController: UINavigationController) {
        var controller: UIViewController;
        if (self.user.staffStatus.lowercaseString == "pracownik" || self.user.staffStatus.lowercaseString == "nauczyciel akademicki") {
            controller = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: NSBundle.mainBundle())
            (controller as! TeacherDetailTableViewController).teacherId = self.user.userId
        } else if (self.user.studentStatus.lowercaseString == "aktywny student") {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: NSBundle.mainBundle())
            (controller as! StudentDetailsTableViewController).userId = self.user.userId
        } else {
            controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: NSBundle.mainBundle())
            (controller as! StudentDetailsTableViewController).userId = self.user.userId
        }

        mainController.pushViewController(controller, animated: true);
    }

}

