//
//  APIUploadProvider.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation


class APIUploadProvider: NSObject, MultipartProviding, URLSessionTaskDelegate, URLSessionDataDelegate {

    typealias SuccessHandlerType = ([APIUploadedFile]) -> Void
    typealias FailureHandlerType = (String) -> Void

    static let shared = APIUploadProvider()

    internal var activeUploads: [APIFile: APIUploadTicket] = [:]

    private var endpointURL: URL {
        let endpointString = String(format:"%@/filesupload", RestApiManager.BASE_URL)
        return URL(string: endpointString)!
    }

    internal func startUpload(file: APIFile,
                              shareOptions: ShareOptions,
                              successHandler: @escaping SuccessHandlerType,
                              failureHandler: @escaping FailureHandlerType,
                              progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        let uploadTicket = APIUploadTicket(file:file, successHandler:successHandler, failureHandler:failureHandler, progressUpdateHandler:progressUpdateHandler)
        let session = APIFileTransferSessionProvider.uploadsSession(delegate: self)

        let ids: String = (shareOptions.sharedWithIds ?? [String]()).joined(separator: ",")
        let parameters: [String : Any] = ["course_id" : file.courseId,
                                            "term_id" : file.termId,
                                            "file_shared_with" : shareOptions.sharedWith?.rawValue ?? "None",
                                            "file_shared_with_ids" :  ids]

        guard
            let fileURL = file.localFileURL,
            let request = createRequestForMultipartUpload(localFileURL:fileURL, parameters:parameters, contentType:file.contentType, to:endpointURL) else {
            return
        }

        uploadTicket.task = session.dataTask(with: request)
        uploadTicket.task?.resume()
        activeUploads[file] = uploadTicket
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }


    func createRequestForMultipartUpload(localFileURL: URL, parameters: [String : Any], contentType: String, to endpointURL: URL) -> URLRequest? {
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        HeaderManager().addHeadersToRequest(&request)
        setupMultipartContentTypeInRequest(&request)
        guard let fileData = try? Data.init(contentsOf: localFileURL) else {
            return nil
        }
        request.httpBody = createMultipartFormData(parameters: parameters, fileName: localFileURL.lastPathComponent, contentType: contentType, fileData: fileData)
        return request
    }

    internal func cancelUpload(file: APIFile) {
        if let uploadTicket = activeUploads[file] {
            uploadTicket.cancel()
        }
    }

    // MARK: URLSessionDataDelegate

    func urlSession( _ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        guard let uploadTicket = activeUploadForTask(dataTask) else {
            return
        }
        uploadTicket.responseData = data

    }

    // MARK: URLSessionTaskDelegate

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        guard let uploadTicket = activeUploadForTask(task) else {
           return
        }

        let file = uploadTicket.file

        UIApplication.shared.isNetworkActivityIndicatorVisible = false


        if taskDidCancelWithError(error) {
            activeUploads[file] = nil
            return
        }

        // error

        if let error = error {
            uploadTicket.failureHandler(error.localizedDescription)
            activeUploads[file] = nil
            return
        }

        if let httpResponse = task.response as? HTTPURLResponse, httpResponse.statusCode != 200 {

            var errorMessage = StringHolder.errorOccures

            if let responseData = uploadTicket.responseData,
                let uploadResponseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

                if let errorResponse = try? ErrorResponse.decode(uploadResponseJSON) {
                    errorMessage = errorResponse.message
                }
            }

            uploadTicket.failureHandler(errorMessage)
            activeUploads[file] = nil
            return
        }

        if let responseData = uploadTicket.responseData,
            let uploadResponseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

            if let uploadResponse = try? APIUploadedFileListResponse.decode(uploadResponseJSON) {
                uploadTicket.successHandler(uploadResponse.files)
                activeUploads[file] = nil
                return
            }

            if let errorResponse = try? ErrorResponse.decode(uploadResponseJSON) {
                uploadTicket.failureHandler(errorResponse.message)
                activeUploads[file] = nil
                return
            }

        }

        uploadTicket.failureHandler(StringHolder.unknownErrorMessage)
        activeUploads[file] = nil

    }

    private func activeUploadForTask( _ task: URLSessionTask) -> APIUploadTicket? {
        var uploadTicket: APIUploadTicket?

        for ( _ , activeUploadTicket) in activeUploads {
            if let uploadTask = activeUploadTicket.task, uploadTask === task {
                uploadTicket = activeUploadTicket
            }
        }
        return uploadTicket
    }

    internal func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

        guard let uploadTicket = activeUploadForTask(task) else {
            return
        }

        uploadTicket.updateProgress(totalBytesProceeded: totalBytesSent, totalSizeInBytes: totalBytesExpectedToSend)
    }

    private func taskDidCancelWithError(_ error: Error?) -> Bool {
        if let error = error, error.localizedDescription == "cancelled" {
            return true
        }
        return false
    }

}
