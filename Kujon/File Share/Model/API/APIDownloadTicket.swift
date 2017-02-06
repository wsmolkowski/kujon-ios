//
//  APIDownload.swift
//  Kujon
//
//  Created by Adam on 22.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class APIDownloadTicket: ProgressTrackable {

    internal var file: APIFile
    internal var task: URLSessionDownloadTask?

    internal var progress: Float = 0.0
    internal var totalBytesProceeded: Int64 = 0
    internal var totalSizeInBytes: Int64 = 0
    internal var progressUpdateHandler: ProgressUpdateHandlerType

    internal var successHandler: APIDownloadProvider.SuccessHandlerType
    internal var failureHandler: APIDownloadProvider.FailureHandlerType

    internal init(file: APIFile,
                   successHandler: @escaping APIDownloadProvider.SuccessHandlerType,
                   failureHandler: @escaping APIDownloadProvider.FailureHandlerType,
                   progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        self.file = file
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.progressUpdateHandler = progressUpdateHandler
    }

    internal func cancel() {
        task?.cancel()
    }

}
