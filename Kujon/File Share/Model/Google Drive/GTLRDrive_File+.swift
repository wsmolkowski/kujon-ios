//
//  GTLRDrive_File+.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


extension GTLRDrive_File {

    internal var isFolder: Bool {
        guard let mimeType = mimeType else {
            return false
        }
        return mimeType == MIMEType.googleFolder.rawValue
    }

    internal var isGoogleDocument: Bool {
        if isFolder {
            return false
        }

        if let isGoogleDocument = mimeType?.contains("application/vnd.google-apps") {
            return isGoogleDocument
        }

        return false
    }

    convenience init(apiFile: APIFile) {
        self.init()
        kind = "drive#file"
        name = apiFile.fileName
        originalFilename = apiFile.fileName
        mimeType = apiFile.contentType
    }

}
