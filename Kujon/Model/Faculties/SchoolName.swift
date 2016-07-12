//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
//"name": {login1633846
//"en": "University of Warsaw",
//"pl": "Uniwersytet Warszawski"
struct SchoolName {
    let pl : String
    let en : String
}
extension SchoolName:Decodable{
    static func decode(j: AnyObject) throws -> SchoolName {
        return try SchoolName(
            pl : j => "pl",
            en : j => "en"
        )
    }

}
