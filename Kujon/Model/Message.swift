//
//  Message.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 25/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable


struct Message {
    let createdTime:String
    let from:String
    let message:String
    let type:String
}


extension Message:Decodable{
    static func decode(_ j: Any) throws -> Message {
        return try Message(createdTime: j => "created_time",
                           from: j => "from",
                           message: j => "message",
                           type: j => "typ")
    }
}
