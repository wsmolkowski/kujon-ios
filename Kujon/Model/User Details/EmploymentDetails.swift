//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct EmploymentDetails {
    let id:String
    let name: String
}
extension EmploymentDetails:Decodable{
    static func decode(_ j: Any) throws -> EmploymentDetails {
        return try EmploymentDetails(
            id: j => "id",
                    name : j => "name"

        )
    }

}
