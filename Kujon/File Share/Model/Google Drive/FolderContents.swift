//
//  FolderContents.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


struct FolderContents: Hashable {

    private let fileList: GTLRDrive_FileList

    internal var currentFolder = GTLRDrive_File() // pass here whole object

    internal var folderId: String {
        get {
            return currentFolder.identifier!
        }
        set (newValue) {
             currentFolder.identifier = newValue
        }
    }

    internal var folderName: String {
        get {
            return currentFolder.name!
        }
        set (newValue) {
            currentFolder.name = newValue
        }
    }


    internal var files: [GTLRDrive_File]? {
        return fileList.toContents.files
    }

    internal var folders: [GTLRDrive_File]? {
        return fileList.toContents.folders
    }

    internal var isFolderEmpty: Bool {
        return noFiles && noFolders
    }

    internal var noFiles: Bool {
        if let files = files {
            return files.isEmpty
        }
        return true
    }

    internal var noFolders: Bool {
        if let folders = folders {
            return folders.isEmpty
        }
        return true
    }

    init(fileList: GTLRDrive_FileList, folderId:String, folderName:String) {
        self.fileList = fileList
        self.folderId = folderId
        self.folderName = folderName
    }

    // Mark: Hashable

    var hashValue: Int {
        return folderId.hashValue
    }

    // Mark: Equatable

    static func == (lhs: FolderContents, rhs: FolderContents) -> Bool {

        guard lhs.hashValue == rhs.hashValue else {
            return false
        }

        guard
            let lhsFiles = lhs.fileList.files,
            let rhsFiles = rhs.fileList.files
            else { return false }

        return lhsFiles == rhsFiles
    }

}
