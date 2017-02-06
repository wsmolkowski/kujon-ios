//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct SimpleUser {
    let firstName: String
    let lastName: String
    let userId: String!
    let id: String?
    let titles: Title?
}


extension SimpleUser: Decodable {
    static func decode(_ j: Any) throws -> SimpleUser {
        return try SimpleUser(
        firstName: j => "first_name",
                lastName: j => "last_name",
                userId: try? j => "user_id",
                id: try? j => "user_id",         // TODO: remove
                titles: try? j => "titles"


        )
    }

    func getPrefix() -> String {
        return self.titles?.before != nil ? self.titles!.before! + " " : ""
    }

     func getSuffix() -> String {
        return self.titles?.after != nil ? self.titles!.after! + " " : ""
    }

    func getNameWithTitles() -> String{
        return getPrefix() + firstName + " " + lastName + getSuffix()
    }

    func fullName() -> String {
        return firstName + " " + lastName
    }


}

extension SimpleUser: SortKeyProviding {

    internal var sortKey: String {
        return lastName + " " + firstName
    }
}

extension SimpleUser: Hashable {

    var hashValue: Int {
        return firstName.hashValue ^ lastName.hashValue
    }
}

extension SimpleUser: Equatable {

    static func == (lhs: SimpleUser, rhs: SimpleUser) -> Bool {
        var userIdsSame: Bool = false
        if lhs.userId == nil && rhs.userId == nil { userIdsSame = true }
        if lhs.userId != nil && rhs.userId != nil && lhs.userId! == rhs.userId! { userIdsSame = true }

        var idsSame: Bool = false
        if lhs.id == nil && rhs.id == nil { idsSame = true }
        if lhs.id != nil && rhs.id != nil && lhs.id! == rhs.id! { idsSame = true }

        return
            lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && userIdsSame && idsSame
    }
    
}
