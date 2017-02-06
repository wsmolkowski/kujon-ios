//
//  APIFileListResponse
//  Kujon
//
//  Created by Adam on 03.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APIFileListResponse: Decodable {

    let status: String
    var files: [APIFile]

    static func decode(_ j: Any) throws -> APIFileListResponse {
        return try APIFileListResponse (
            status: j => "status",
            files: j => "data"
        )
    }

}
