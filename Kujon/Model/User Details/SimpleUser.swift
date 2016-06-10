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

//
//"last_name": "G\u00f3ralowski",
//"first_name": "Marek",
//"titles": {
//    "after": null,
//    "before": "dr"
//},
//"id": "1"

extension SimpleUser: Decodable {
    static func decode(j: AnyObject) throws -> SimpleUser {
        return try SimpleUser(
        firstName: j => "first_name",
                lastName: j => "last_name",
                userId: try? j => "userId",
                id: j => "id",
                titles: try? j => "titles"


        )
    }


}