//
//  APIFileOwner.swift
//  Kujon
//
//  Created by Adam on 03.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APIFileOwner: Decodable {

    let firstName: String
    let lastName: String
    let usosUserId: String

    static func decode(_ j: Any) throws -> APIFileOwner {
        return try APIFileOwner (
            firstName: j => "first_name",
            lastName: j => "last_name",
            usosUserId: j => "user_id"
        )
    }
    
}
