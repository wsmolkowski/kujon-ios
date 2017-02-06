//
//  DriveUploadTicket.swift
//  Kujon
//
//  Created by Adam on 02.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class DriveUploadTicket: ProgressTrackable {

    internal var ticket: GTLRServiceTicket?

    internal var progress: Float = 0.0
    internal var totalBytesProceeded: Int64 = 0
    internal var totalSizeInBytes: Int64 = 0
    internal var successHandler: DriveManager.UploadResponseHandler
    internal var failureHandler: DriveManager.ErrorResponseHandler
    internal var progressUpdateHandler: ProgressUpdateHandlerType

    internal init(successHandler: @escaping DriveManager.UploadResponseHandler,
                  failureHandler: @escaping DriveManager.ErrorResponseHandler,
                  progressUpdateHandler: @escaping ProgressUpdateHandlerType) {

        self.successHandler = successHandler
        self.failureHandler = failureHandler
        self.progressUpdateHandler = progressUpdateHandler
    }

    internal func cancel() {
        ticket?.cancel()
    }

    deinit {
        ticket = nil
    }
}
