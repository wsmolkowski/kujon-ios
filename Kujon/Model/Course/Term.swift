//
// Created by Wojciech Maciejewski on 29/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//    "name": "Rok akademicki 2015/16",
//    "end_date": "2016-06-08",
//    "finish_date": "2016-09-30",
//    "term_id": "2015",
//    "active": true,
//    "start_date": "2015-10-01"
//},

struct Term {
    let name: String
    let endDate: String
    let finishDate: String
    let termId: String
    let active: Bool
    let startDate: String
}


extension Term: Decodable {
    static func decode(j: AnyObject) throws -> Term {
        return try Term(
        name: j => "name",
                endDate: j => "end_date",
                finishDate: j => "finish_date",
                termId: j => "term_id",
                active: j => "active",
                startDate: j => "start_date"
        )
    }

}