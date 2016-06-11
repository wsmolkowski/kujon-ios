//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Programme {
    let name: String?
    let modeOfStudies: String?
    let duration: String?
    let levelOfStudies: String?
    let id: String
    let description: String
}

extension Programme: Decodable {
    static func decode(j: AnyObject) throws -> Programme {
        return try Programme(
                name:  try? j => "name",
                modeOfStudies: try? j => "mode_of_studies",
                duration: try? j => "duration",
                levelOfStudies: try? j => "level_of_studies",
                id: j => "id",
                description: j => "description"
        )
    }
}