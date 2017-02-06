//
//  FileManager+.swift
//  Kujon
//
//  Created by Adam on 16.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension FileManager {

    static func directoryURL(for directory:SearchPathDirectory) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: directory, in: .userDomainMask)
        return urls.first
    }

    static func sizeOfFile(url:URL) -> UInt64? {
        let filePath = url.path
        if let attr = try? FileManager.default.attributesOfItem(atPath: filePath) {
            let fileSize: UInt64 = attr[FileAttributeKey.size] as! UInt64
            return fileSize
        }
        return nil
    }
    
}
