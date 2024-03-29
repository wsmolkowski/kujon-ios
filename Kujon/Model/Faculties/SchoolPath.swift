//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct SchoolPath {

    let id : String
    let schoolName : String
}

extension SchoolPath:Decodable{
    static func decode(_ j: Any) throws -> SchoolPath {
        return try SchoolPath(
            id: j => "id",
            schoolName: j => "name"

        )
    }

}
