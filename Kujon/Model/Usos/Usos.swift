//
// Created by Wojciech Maciejewski on 08/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct Usos {
    let name: String
    let usosId: String
    let image: String
    let enable: Bool!
    let comment: String!

}

extension Usos: Decodable {
    static func decode(j: AnyObject) throws -> Usos {
        return try Usos(
        name: j => "name",
                usosId: j => "usos_id",
                image: j => "logo",
                enable: try? j =>  "enabled",
                comment: try? j => "comment"
        )
    }
}