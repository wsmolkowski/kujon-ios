//
//  URL+.swift
//  Kujon
//
//  Created by Adam on 16.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension URL {

    static func createURLForFileName( _ fileName:String, in directory: FileManager.SearchPathDirectory) -> URL? {
        
        guard let directoryURL = FileManager.directoryURL(for: directory) else {
            return nil
        }
        return directoryURL.appendingPathComponent(fileName)
    }

    static func createCacheURLForFile( _ file: GTLRDrive_File) -> URL? {
        guard let fileName = file.name else {
            return nil
        }
        return URL.createURLForFileName(fileName, in: .cachesDirectory)
    }

    var fileTypeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }

}
