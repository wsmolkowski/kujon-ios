//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

//"path": [
//{
//"id": "00000000",
//"name": {
//"en": "University of Warsaw",
//"pl": "Uniwersytet Warszawski"
//}
struct SchoolPath {

    let id : String
    let schoolName : SchoolName
}

extension SchoolPath:Decodable{
    static func decode(j: AnyObject) throws -> SchoolPath {
        return try SchoolPath(
            id: j => "id",
            schoolName: j => "name"

        )
    }

}