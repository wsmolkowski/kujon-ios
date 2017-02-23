//
//  DriveFolderContentsProvider
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


class DriveFolderContentsProvider: FolderContentsProviding {

    internal weak var delegate: FolderContentsProvidingDelegate?
    internal var cache: FolderContentsCachable?
    internal var isFetching: Bool {  return drive?.isFetchingFileList ?? false }
    private let drive = DriveManager.shared

    internal func loadContentsForRootFolder() {
        loadContents(folderId:kDriveRootFolderId, folderName:StringHolder.rootFolderName)
    }

    internal func loadContents(folder: GTLRDrive_File) {

        guard let id = folder.identifier, let name = folder.name  else {
            return
        }
        loadContents(folderId:id, folderName:name)
    }

    internal func loadContents(folderId:String, folderName:String) {

        if let cachedContents = cache?.loadItem(folderId: folderId) {
            self.delegate?.folderContentsProvider(provider: self, didLoadContents: cachedContents, forFolderId: folderId)
            return
        }

        guard let drive = drive else {
            self.delegate?.folderContentsProvider(provider: self, didFailWithErrorMessage: StringHolder.userNotLoggedInToGoogleMessage)
            return
        }

        if drive.isFetchingFileList {
            drive.cancelFileListFetch()
        }

        drive.fetchFileListForFolderId(folderId, success: { [unowned self] fileList in
            let contents = FolderContents(fileList:fileList, folderId:folderId, folderName:folderName)
            self.cache?.save(item: contents)
            self.delegate?.folderContentsProvider(provider: self, didLoadContents: contents, forFolderId: folderId)

        }, failure: { [unowned self] errorMessage in
            self.delegate?.folderContentsProvider(provider: self, didFailWithErrorMessage: errorMessage)
        })
    }

    internal func cancelFetch() {
        drive?.cancelFileListFetch()
    }

    deinit {
        drive?.cancelFileListFetch()
    }

}
