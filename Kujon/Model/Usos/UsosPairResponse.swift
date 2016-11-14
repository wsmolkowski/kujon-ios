//
//  UsosPairResponse.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 14/11/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct UsosPaired{
    let status: String
    let message: String
}

extension UsosPaired: Decodable {
    static func decode(_ j: Any) throws -> UsosPaired {
        return try UsosPaired(
            status: j => "status",
            message: j => "data"
        )
    }
    
}
