//
//  GTLRDrive_FileList+.swift
//  Kujon
//
//  Created by Adam on 02.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

extension GTLRDrive_FileList {

    typealias Contents = (folders:[GTLRDrive_File]?, files:[GTLRDrive_File]?)
    typealias FilterMethod = (GTLRDrive_File) -> Bool

    func contentsFiltered(filterMethod: FilterMethod) -> Contents {
        guard let files = self.files else {
            return (folders:nil, files:nil)
        }
        let contents = files.filter(filterMethod)
        let filteredFolders = contents.filter { $0.isFolder }
        let filteredFiles = contents.filter { !$0.isFolder }
        return (folders:filteredFolders, files:filteredFiles)

    }

    func contentsInFolder(folderId: String) -> Contents {
        return contentsFiltered {
            if let parents = $0.parents {
                return parents.joined().contains(folderId)
            }
            return false
        }
    }

    var toContents: Contents {
        return contentsFiltered { _ in return true }
    }

}
