//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct These : Decodable{

    let authors:Array<SimpleUser>
    let faculty:FacultyShort
    let id : String
    let title: String
    let type: String
    let sypervisors: Array<SimpleUser>

    static func decode(j: AnyObject) throws -> These {
        return try These(authors: j => "authors",
                faculty: j => "faculty",
                id: j => "id",
                title: j => "title",
                type: j => "type", sypervisors: j => "supervisors")
    }

}
