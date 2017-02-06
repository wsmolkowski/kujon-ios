//
//  APIFile.swift
//  Kujon
//
//  Created by Adam on 22.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import Decodable
import GoogleAPIClientForREST

struct APIFile: Decodable, Hashable {

    var localFileURL: URL?
    var fileId: String?
    let createdTime: String?
    let fileName: String
    let courseId: String
    let termId: String
    var contentType: String
    var fileSize: String?
    var firstName: String?
    var lastName: String?
    var usosUserId: String?
    var fileSharedByMe: Bool?
    var shareOptions: ShareOptions

    init(fileName: String, courseId: String, termId: String, shareOptions: ShareOptions, fileSharedByMe: Bool? = true, contentType: String, localFileURL: URL? = nil, firstName: String? = nil, lastName: String? = nil, usosUserId: String? = nil, fileId: String? = nil, createdTime: String? = nil, fileSize: String? = nil) {
        self.fileName = fileName
        self.fileId = fileId
        self.courseId = courseId
        self.termId = termId
        self.createdTime = createdTime
        self.contentType = contentType
        self.fileSize = fileSize
        self.localFileURL = localFileURL
        self.firstName = firstName
        self.lastName = lastName
        self.usosUserId = usosUserId
        self.shareOptions = shareOptions
        self.fileSharedByMe = fileSharedByMe
    }

    init?(localFileURL:URL, courseId:String, termId:String, shareOptions: ShareOptions, contentType: String = MIMEType.binary.rawValue) {

        guard let _ = try? localFileURL.checkPromisedItemIsReachable() else {
            return nil
        }

        self.init(fileName:localFileURL.lastPathComponent, courseId:courseId, termId:termId, shareOptions: shareOptions, contentType: contentType)

        self.localFileURL = localFileURL
    }

    // MARK: Decodable

    static func decode(_ j: Any) throws -> APIFile {
        let sharedWithString: String = try j => "file_shared_with"
        let sharedWith = ShareOptions.SharedWith(rawValue: sharedWithString)
        let shareOptions = ShareOptions(sharedWith: sharedWith, ids: try? j => "file_shared_with_ids")

        return try APIFile(
            fileName: j => "file_name",
            courseId: j => "course_id",
            termId: j => "term_id",
            shareOptions: shareOptions,
            fileSharedByMe: try? j => "file_shared_by_me",
            contentType: j => "file_content_type",
            firstName: j => "first_name",
            lastName: j => "last_name",
            usosUserId: j => "usos_user_id",
            fileId: try? j => "file_id",
            createdTime: try? j => "created_time",
            fileSize: try? j => "file_size"
        )
    }

    // MARK: Hashable

    var hashValue: Int {
        return fileName.hashValue ^ courseId.hashValue
    }

    // Mark: Equatable

    static func == (lhs: APIFile, rhs: APIFile) -> Bool {

        var idsAreEqual: Bool = false

        if let lhsId = lhs.fileId, let rhsId = rhs.fileId, lhsId == rhsId {
            idsAreEqual = true
        }
        if lhs.fileId == nil && rhs.fileId == nil {
            idsAreEqual = true
        }

        return lhs.fileName == rhs.fileName
            && lhs.courseId == rhs.courseId
            && lhs.termId == rhs.termId
            && lhs.contentType == rhs.contentType
            && idsAreEqual
    }

}
