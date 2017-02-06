//
//  APIUploadedFileListResponse
//  Kujon
//
//  Created by Adam on 03.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import Decodable

struct APIUploadedFileListResponse: Decodable {

    let code: Int
    let status: String
    var files: [APIUploadedFile]

    static func decode(_ j: Any) throws -> APIUploadedFileListResponse {
        return try APIUploadedFileListResponse (
            code: j => "code",
            status: j => "status",
            files: j => "data"
        )
    }
    
}
