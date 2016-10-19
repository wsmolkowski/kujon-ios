//
// Created by Wojciech Maciejewski on 01/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct ProgrammeWithDifferentId {
    let name: String?
    let modeOfStudies: String?
    let duration: String?
    let levelOfStudies: String?
    let id: String
    let description: String
    let ectsUsedSum: Double?
}


extension ProgrammeWithDifferentId: Decodable {
    static func decode(_ j: Any) throws -> ProgrammeWithDifferentId {
        return try ProgrammeWithDifferentId(
                name: try? j => "name",
                modeOfStudies: try? j => "mode_of_studies",
                duration: try? j => "duration",
                levelOfStudies: try? j => "level_of_studies",
                id: j => "programme_id",
                description: j => "name",
                ectsUsedSum: try? j => "ects_used_sum"
                )
    }
}

extension ProgrammeWithDifferentId {
    func getProgramme() -> Programme {
        return Programme(name: self.name, modeOfStudies: self.modeOfStudies, duration: self.duration, levelOfStudies: self.levelOfStudies, id: self.id, description: self.description, ectsUsedSum: self.ectsUsedSum)
    }
}
