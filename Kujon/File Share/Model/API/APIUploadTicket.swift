//
//  APIUpload.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class APIUploadTicket: ProgressTrackable {

    internal let file: APIFile
    internal var task: URLSessionDataTask?
    internal var responseData: Data?

    internal var progress: Float = 0.0
    internal var totalBytesProceeded: Int64 = 0
    internal var totalSizeInBytes: Int64 = 0
    internal var progressUpdateHandler: ProgressUpdateHandlerType

    internal var successHandler: APIUploadProvider.SuccessHandlerType
    internal var failureHandler: APIUploadProvider.FailureHandlerType

    internal init(file: APIFile,
                  successHandler: @escaping APIUploadProvider.SuccessHandlerType,
                  failureHandler: @escaping APIUploadProvider.FailureHandlerType,
                  progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        self.file = file
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.progressUpdateHandler = progressUpdateHandler    }

    internal func cancel() {
        task?.cancel()
    }
}
