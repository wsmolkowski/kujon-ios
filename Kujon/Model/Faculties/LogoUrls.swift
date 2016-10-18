//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct LogoUrls {
    let p100x100 : String
}


extension LogoUrls:Decodable{
    static func decode(_ j: Any) throws -> LogoUrls {
        return try LogoUrls(
            p100x100: j => "100x100"
        )
    }

}
