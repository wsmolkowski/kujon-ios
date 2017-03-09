//
//  RestApiManager+.swift
//  Kujon
//
//  Created by Adam on 21.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class APIDownloadProvider: NSObject, URLSessionDownloadDelegate {

    typealias SuccessHandlerType = (URL) -> Void
    typealias FailureHandlerType = (String) -> Void

    static let shared = APIDownloadProvider()
    internal var activeDownloads: [APIFile: APIDownloadTicket] = [:]

    private func endpointForFileId( _ fileId: String) -> URL? {
        let endpointString = String(format: "%@/files/%@", RestApiManager.BASE_URL,fileId)
        return URL(string: endpointString)
    }

    internal func startDownload(file: APIFile,
                                successHandler: @escaping SuccessHandlerType,
                                failureHandler: @escaping FailureHandlerType,
                                progressUpdateHandler: @escaping ProgressUpdateHandlerType) {


        guard let fileId = file.fileId, let endpointURL = endpointForFileId(fileId) else {
            return
        }
        let downloadTicket = APIDownloadTicket(file:file, successHandler:successHandler, failureHandler:failureHandler, progressUpdateHandler: progressUpdateHandler)
        let session = APIFileTransferSessionProvider.downloadsSession(delegate: self)
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "GET"
        HeaderManager().addHeadersToRequest(&request)
        downloadTicket.task = session.downloadTask(with: request)
        downloadTicket.task?.resume()
        activeDownloads[file] = downloadTicket
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }

    internal func cancelDownload(file: APIFile) {
        if let downloadTicket = activeDownloads[file] {
            downloadTicket.cancel()
        }
    }

    // MARK: URLSessionDownloadDelegate

    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        guard let downloadTicket = activeDownloadForTask(downloadTask) else {
            return
        }
        let file = downloadTicket.file
        let fileManager = FileManager.default

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        if let errorResponse = isErrorResponse(at: location) {
            downloadTicket.failureHandler(errorResponse.message)
            activeDownloads[file] = nil
            try? fileManager.removeItem(at: location)
            return
        }

        guard let destinationURL = URL.createURLForFileName(file.fileName, in: .cachesDirectory) else {
            downloadTicket.failureHandler(StringHolder.noCachesDirectory)
            activeDownloads[file] = nil
            return
        }

        try? fileManager.removeItem(at: destinationURL)

        do {
            defer {
                activeDownloads[file] = nil
            }
            try fileManager.copyItem(at: location, to: destinationURL)
            downloadTicket.successHandler(destinationURL)
            try? fileManager.removeItem(at: location)

        } catch let error {
            downloadTicket.failureHandler(error.localizedDescription)
        }

    }

    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        guard let downloadTicket = activeDownloadForTask(task) else {
            return
        }

        let file = downloadTicket.file

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        if taskDidCancelWithError(error) {
            activeDownloads[file] = nil
            return
        }

        if let error = error {
            downloadTicket.failureHandler(error.localizedDescription)
            activeDownloads[file] = nil
            return
        }

        if let httpResponse = task.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let message: String = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            downloadTicket.failureHandler(message)
            activeDownloads[file] = nil
            return
        }

    }

    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard let downloadTicket = activeDownloadForTask(downloadTask) else {
            return
        }

        downloadTicket.updateProgress(totalBytesProceeded: totalBytesWritten, totalSizeInBytes: totalBytesExpectedToWrite)
    }

    // MARK: Helpers

    private func activeDownloadForTask( _ task: URLSessionTask) -> APIDownloadTicket? {
        var downloadTicket: APIDownloadTicket?

        for ( _ , activeDownloadTicket) in activeDownloads {
            if let downloadTask = activeDownloadTicket.task, downloadTask === task {
                downloadTicket = activeDownloadTicket
            }
        }
        return downloadTicket
    }

    private func isErrorResponse(at url: URL) -> ErrorResponse? {

        guard

            let errorResponseData = try? Data.init(contentsOf: url),
            let errorResponseJSON = try? JSONSerialization.jsonObject(with: errorResponseData, options: .allowFragments),
            let errorResponse = try? ErrorResponse.decode(errorResponseJSON)

            else { return nil }

        return errorResponse
    }

    private func taskDidCancelWithError(_ error: Error?) -> Bool {
        if let error = error, error.localizedDescription == "cancelled" {
            return true
        }
        return false
    }
}
