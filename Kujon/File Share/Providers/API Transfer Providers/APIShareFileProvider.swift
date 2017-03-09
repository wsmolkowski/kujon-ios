//
//  APIShareFileProvider
//  Kujon
//
//  Created by Adam on 09.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class APIShareFileProvider {

    typealias SuccessHandlerType = (APISharedFile) -> Void
    typealias FailureHandlerType = (String) -> Void

    private let session = SessionManager.provideSession()
    private var task: URLSessionDataTask?

    private var endpointURL: URL {
        let endpointString = String(format:"%@/filesshare", RestApiManager.BASE_URL)
        return URL(string: endpointString)!
    }

    private func parameters(fileId: String, shareOptions: ShareOptions) -> [[String : Any]] {
        return [[ "file_id" : fileId,
                 "file_shared_with" : shareOptions.sharedWith?.rawValue ?? "None",
                 "file_shared_with_ids" : shareOptions.sharedWithIds ?? [String]()]]
    }

    internal func shareFile( _ fileId: String, shareOptions: ShareOptions, successHandler: @escaping SuccessHandlerType, failureHandler: @escaping FailureHandlerType) {

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        HeaderManager().addHeadersToRequest(&request)
        let parameters = self.parameters(fileId: fileId, shareOptions: shareOptions)
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        task = session.dataTask(with: request) { responseData, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if let error = error {
                failureHandler(error.localizedDescription)
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {

                var errorMessage = StringHolder.fileShareError

                if let responseData = responseData,
                    let uploadResponseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

                    if let errorResponse = try? ErrorResponse.decode(uploadResponseJSON) {
                        errorMessage = errorResponse.message
                    }
                }
                
                failureHandler(errorMessage)
                return
            }

            if let responseData = responseData,
                let sharedFileResponseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {

                if let sharedFileResponse = try? APISharedFileListResponse.decode(sharedFileResponseJSON) {
                    successHandler(sharedFileResponse.file)
                    return
                }

                if let errorResponse = try? ErrorResponse.decode(sharedFileResponseJSON) {
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
