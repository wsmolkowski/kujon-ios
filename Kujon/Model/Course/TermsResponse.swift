//
// Created by Wojciech Maciejewski on 12/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
struct TermsResponse {
    let status: String
    let terms: Array<Term>
}


extension TermsResponse:Decodable{
    static func decode(_ j: Any) throws -> TermsResponse {
        return try TermsResponse(
        status: j => "status",
                terms: j => "data"
        )
    }
}
