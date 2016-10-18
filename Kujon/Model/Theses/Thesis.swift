//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Thesis : Decodable{

    let authors:Array<SimpleUser>
    let faculty:FacultyShort
    let id : String
    let title: String
    let type: String
    let supervisors: Array<SimpleUser>

    static func decode(_ j: Any) throws -> Thesis {
        return try Thesis(authors: j => "authors",
                faculty: j => "faculty",
                id: j => "id",
                title: j => "title",
                type: j => "type",
                supervisors: j => "supervisors")
    }

}
