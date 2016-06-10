//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct StudentProgramme {
    let id: String
    let programme: Programme
}

extension StudentProgramme: Decodable {
    static func decode(j: AnyObject) throws -> StudentProgramme {
        return try StudentProgramme(
                id: j => "id",
                programme: j => "programme"
        )
    }

}
