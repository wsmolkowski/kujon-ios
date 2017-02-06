//
//  DriveDownload.swift
//  Kujon
//
//  Created by Adam on 02.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class DriveDownloadTicket: ProgressTrackable {

    internal var fetcher: GTMSessionFetcher?

    internal var progress: Float = 0.0
    internal var totalBytesProceeded: Int64 = 0
    internal var totalSizeInBytes: Int64 = 0
    internal var progressUpdateHandler: ProgressUpdateHandlerType

    internal var successHandler: DriveManager.DownloadResponseHandler
    internal var failureHandler: DriveManager.ErrorResponseHandler

    internal init(successHandler: @escaping DriveManager.DownloadResponseHandler,
                  failureHandler: @escaping DriveManager.ErrorResponseHandler,
                  progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.progressUpdateHandler = progressUpdateHandler
    }

    internal func cancel() {
        fetcher?.stopFetching()
    }
    
}
