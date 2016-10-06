//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
//"id": "10000000",
//"name": "Wydzia\u0142 Matematyki, Informatyki i Mechaniki"
struct FacultyShort : Decodable{
    let id: String
    let name: String

    static func decode(json: AnyObject) throws -> FacultyShort {
        return try FacultyShort(id: json => "id", name: json => "name")
    }

}
