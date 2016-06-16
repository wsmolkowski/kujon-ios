//
// Created by Wojciech Maciejewski on 16/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct EmploymentPosition {

    let position: EmploymentDetails
    let faculty: EmploymentDetails
}


extension EmploymentPosition:Decodable{
    static func decode(j: AnyObject) throws -> EmploymentPosition {
        return try EmploymentPosition(
            position: j => "position",
                    faculty: j => "faculty"
        )
    }

}