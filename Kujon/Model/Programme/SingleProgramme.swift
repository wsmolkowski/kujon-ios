//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct SingleProgramme {
    let id: String
    let programmeWithId: ProgrammeWithDifferentId
}

extension SingleProgramme: Decodable {
    static func decode(j: AnyObject) throws -> SingleProgramme {
        return try SingleProgramme(
                id: j => "id",
                programmeWithId: j => "programme"
                )
    }

}
