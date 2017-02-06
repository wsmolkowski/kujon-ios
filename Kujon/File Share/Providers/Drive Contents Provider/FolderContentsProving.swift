//
//  FolderContentsProviding.swift
//  Kujon
//
//  Created by Adam on 18.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol FolderContentsProvidingDelegate: class {

    func folderContentsProvider(provider:FolderContentsProviding, didLoadContents contents:FolderContents, forFolderId folderId:String)
    func folderContentsProvider(provider:FolderContentsProviding, didFailWithErrorMessage message:String)
}

protocol FolderContentsProviding {

    var cache: FolderContentsCachable? { get set }
    var delegate: FolderContentsProvidingDelegate? { get set }
    var isFetching: Bool { get }
    
    func loadContentsForRootFolder()
    func loadContents(folder: GTLRDrive_File)
    func cancelFetch()
    
}
