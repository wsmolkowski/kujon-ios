//
//  DriveManager.swift
//  Kujon
//
//  Created by Adam on 01.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

enum DriveManagerError: Error {
    case couldNotWriteFile
    case fileNotFound
    case notEnoughFreeSpaceAvailable
    case invalidGoogleDriveFileIdentifier
    case cannotDownloadFile
    case cannotExportFile
    case cannotMapExportFormat
}

class DriveManager {

    typealias FileListResponseHandler = (GTLRDrive_FileList) -> Void
    typealias DownloadResponseHandler = (URL) -> Void
    typealias UploadResponseHandler = (GTLRDrive_File) -> Void
    typealias ErrorResponseHandler = (String) -> Void

    internal var defaultQueries: [DriveQuery] = [ .trashed(false) ]
    internal var isFetchingFileList: Bool { return fileListFetchTicket != nil }

    private var service: GTLRDriveService?
    private var fileListFetchTicket: GTLRServiceTicket?
    private var activeDownloads: [GTLRDrive_File: DriveDownloadTicket] = [:]
    private var activeUploads: [URL: DriveUploadTicket] = [:]
    private let app = UIApplication.shared


    internal static let shared: DriveManager? = {
        if let gidSignIn = GIDSignIn.sharedInstance(),
            let user = gidSignIn.currentUser,
            let authentication = user.authentication,
            let authorizer = authentication.fetcherAuthorizer() {
            let manager = DriveManager()
            let service = GTLRDriveService()
            service.shouldFetchNextPages = true
            service.isRetryEnabled = true
            service.authorizer = authorizer
            manager.service = service
            return manager
        }
        return nil
    }()


    // MARK: Fetch drive contents

    func fetchAllFileList(success: @escaping FileListResponseHandler, failure: @escaping ErrorResponseHandler) {
        let query = DriveQuery.allDriveContents
        fetchFileList(queries: [query], success: success, failure: failure)
    }

    func fetchFileListForRootFolder(success: @escaping FileListResponseHandler, failure: @escaping ErrorResponseHandler) {
        let query = DriveQuery.rootFolderContents
        fetchFileList(queries: [query], success: success, failure: failure)
    }

    func fetchFileListForFolderId(_ folderId:String, success: @escaping FileListResponseHandler, failure: @escaping ErrorResponseHandler) {
        let query = DriveQuery.contentsInFolderId(folderId)
        fetchFileList(queries: [query], success: success, failure: failure)
    }

    func fetchFileList(queries:[DriveQuery], success: @escaping FileListResponseHandler, failure: @escaping ErrorResponseHandler) {

        let filesListQuery = GTLRDriveQuery_FilesList.query()
        filesListQuery.fields = DriveQueryFields.deafultFields
        let allQueries = defaultQueries + queries
        filesListQuery.q = allQueries.toDriveQueryString()

        app.isNetworkActivityIndicatorVisible = true
        fileListFetchTicket = service?.executeQuery(filesListQuery) { [weak self] ticket, fileList, error in
            self?.app.isNetworkActivityIndicatorVisible = false
            self?.fileListFetchTicket = nil
            if let error = error {
                failure(error.localizedDescription)
                return
            }
            success(fileList as! GTLRDrive_FileList)
        }
    }

    func cancelFileListFetch() {
        fileListFetchTicket?.cancel()
        fileListFetchTicket = nil
    }

    // MARK: File transfer

    func downloadFile( _ file: GTLRDrive_File, toDirectory directoryURL:URL, success: @escaping DownloadResponseHandler, failure: @escaping ErrorResponseHandler, progressUpdateHandler: @escaping ProgressUpdateHandlerType) throws {

        guard
            let fileId = file.identifier,
            var fileName = file.name else {
                throw DriveManagerError.cannotDownloadFile
        }

        if file.isFolder {
            throw DriveManagerError.cannotDownloadFile
        }

        var query: GTLRDriveQuery

        if file.isGoogleDocument {
            let format = try DriveExportFormat.mapFormat(for:file)
            fileName += "." + format.fileExtension
            query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId:fileId, mimeType:format.mimeType.rawValue)
        } else {
            query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId:fileId)
        }

        let destinationFileURL: URL = directoryURL.appendingPathComponent(fileName)

        /// TODO: move to operation
        let deviceFreeSpace = UIDevice.freeSpaceInBytes() ?? 0
        let fileSize = file.size?.int64Value ?? 0

        guard deviceFreeSpace > fileSize else {
            throw DriveManagerError.notEnoughFreeSpaceAvailable
        }
        ///

        let downloadTicket = DriveDownloadTicket(successHandler: success, failureHandler: failure, progressUpdateHandler: progressUpdateHandler)

        guard let nsMutableRequest: NSMutableURLRequest = service?.request(for: query) else {
            return
        }
        let request = nsMutableRequest as URLRequest
        let fetcher = service?.fetcherService.fetcher(with: request)
        fetcher?.destinationFileURL = destinationFileURL
        fetcher?.downloadProgressBlock = { _ , totalBytesWritten, totalBytesExpectedToWrite in
            downloadTicket.updateProgress(totalBytesProceeded: totalBytesWritten, totalSizeInBytes: totalBytesExpectedToWrite)
        }

        app.isNetworkActivityIndicatorVisible = true

        fetcher?.beginFetch { [weak self] fileData, callbackError in
            self?.app.isNetworkActivityIndicatorVisible = false

            if let error = callbackError {
                downloadTicket.failureHandler(error.localizedDescription)
                self?.activeDownloads[file] = nil
                return
            }

            downloadTicket.successHandler(destinationFileURL)
            self?.activeDownloads[file] = nil
        }
        activeDownloads[file] = downloadTicket
    }

    func cancelDownload(file: GTLRDrive_File) {
        if let downloadTicket = activeDownloads[file] {
            downloadTicket.cancel()
            activeDownloads[file] = nil
            app.isNetworkActivityIndicatorVisible = false
        }
    }

    func uploadFile(fileURL:URL, destinationFolderId:String? = nil, success: @escaping UploadResponseHandler, failure: @escaping ErrorResponseHandler, progressUpdateHandler: @escaping ProgressUpdateHandlerType) throws {

        guard let _ = try? fileURL.checkPromisedItemIsReachable() else {
            throw DriveManagerError.fileNotFound
        }

        let filename = fileURL.lastPathComponent
        let mimeType = MIMEType.binary.rawValue

        let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)

        let uploadedFile = GTLRDrive_File()
        uploadedFile.name = filename
        uploadedFile.mimeType = MIMEType.binary.rawValue
        if let destinationFolderId = destinationFolderId {
            uploadedFile.parents = [destinationFolderId]
        }

        let uploadTicket = DriveUploadTicket(successHandler: success, failureHandler: failure, progressUpdateHandler: progressUpdateHandler)

        let uploadProgressBlock: GTLRServiceUploadProgressBlock = { _ , numberOfBytesRead, dataLength in
            uploadTicket.updateProgress(totalBytesProceeded: Int64(numberOfBytesRead), totalSizeInBytes: Int64(dataLength))
        }

        let query = GTLRDriveQuery_FilesCreate.query(withObject: uploadedFile, uploadParameters:uploadParameters)
        query.executionParameters.uploadProgressBlock = uploadProgressBlock

        app.isNetworkActivityIndicatorVisible = true

        uploadTicket.ticket = service?.executeQuery(query) { [weak self] (ticket, uploadedFile, error) in

            self?.app.isNetworkActivityIndicatorVisible = false

            if let error = error {
                uploadTicket.failureHandler(error.localizedDescription)
                self?.activeUploads[fileURL] = nil
                return
            }
            uploadTicket.successHandler(uploadedFile as! GTLRDrive_File)
            self?.activeUploads[fileURL] = nil
        }
        activeUploads[fileURL] = uploadTicket
    }
    
    func cancelUpload(fileURL:URL) {
        if let uploadTicket = activeUploads[fileURL] {
            uploadTicket.cancel()
            activeUploads[fileURL] = nil
            app.isNetworkActivityIndicatorVisible = false
        }
    }

}
