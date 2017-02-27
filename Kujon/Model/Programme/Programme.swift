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
    let description: String?
    let ectsUsedSum: Double?
    let schoolPath: SchoolPath?

    var nameShort: String? {
        let comma = ","
        if let name = name, name.contains(comma), !name.hasPrefix(comma) {
            return name.components(separatedBy: comma).first!
        }
        return nil
    }
}

extension Programme: Decodable {
    static func decode(_ j: Any) throws -> Programme {
        return try Programme(
                name:  try? j => "name",
                modeOfStudies: try? j => "mode_of_studies",
                duration: try? j => "duration",
                levelOfStudies: try? j => "level_of_studies",
                id: j => "id",
                description: try? j => "description",
                ectsUsedSum: try? j => "ects_used_sum",
                schoolPath: try? j => "faculty"

        )
    }
}
