//
//  MessageResponse.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 25/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct MessageResponse:Decodable {
    let status: String
    let data : Array<Message>
    
    static func decode(_ j: Any) throws -> MessageResponse {

        return try MessageResponse(
            status: j => "status",
            data: j => "data"
        )
    }
    
}
