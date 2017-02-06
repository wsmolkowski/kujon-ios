//
//  APIDeletionProvider
//  Kujon
//
//  Created by Adam on 10.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class APIDeletionProvider {

    typealias SuccessHandlerType = (String) -> Void
    typealias FailureHandlerType = (String) -> Void

    private let session = SessionManager.provideSession()
    private var task: URLSessionDataTask?

    private func endpointForFileId( _ fileId: String) -> URL? {
        let endpointString = String(format: "%@/files/%@", RestApiManager.BASE_URL,fileId)
        return URL(string: endpointString)
    }

    internal func deleteFile( _ file: APIFile, successHandler: @escaping SuccessHandlerType, failureHandler: @escaping FailureHandlerType) {

        guard let fileId = file.fileId else {
            return
        }

        var request = URLRequest(url: endpointForFileId(fileId)!)
        request.httpMethod = "DELETE"
        HeaderManager().addHeadersToRequest(&request)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        task = session.dataTask(with: request) { responseData, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if let error = error {
                failureHandler(error.localizedDescription)
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {

                var errorMessage = StringHolder.fileDeleteError

                if let responseData = responseData,
                    let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

                    if let errorResponse = try? ErrorClass.decode(responseJSON) {
                        errorMessage = errorResponse.message
                    }
                }

                failureHandler(errorMessage)
                return
            }

            if let responseData = responseData,
                let deleteFileResponseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

                if let deleteFileResponse = try? APIDeleteFileResponse.decode(deleteFileResponseJSON) {
                    successHandler(deleteFileResponse.fileId)
                    return
                }

                if let errorResponse = try? ErrorClass.decode(deleteFileResponseJSON) {
                    failureHandler(errorResponse.message)
                    return
                }

            }

            failureHandler(StringHolder.unknownErrorMessage)
        }
        
        task?.resume()
    }
    
    
    internal func cancel() {
        task?.cancel()
    }
    
}
