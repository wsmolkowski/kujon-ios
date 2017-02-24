//
//  Drive2APITransfer
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class Drive2APITransfer: Transferable, OperationDelegate {

    private let file: GTLRDrive_File
    private let courseId: String
    private let termId: String
    private let shareOptions: ShareOptions

    private var downloadProgress: Float = 0.0
    private var uploadProgress: Float = 0.0
    private var transferProgress: Float { return downloadProgress / 2.0 + uploadProgress / 2.0 }
    internal var type: TransferType = .add
    private var transferDidFail = false

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?


    init(file:GTLRDrive_File, assignApiCourseId courseId:String, termId:String, shareOptions: ShareOptions) {
        self.file = file
        self.courseId = courseId
        self.termId = termId
        self.shareOptions = shareOptions
    }

    func createOperations() -> [Operation] {
        let downloadOperation = DriveDownloadFileOperation(file: file)
        downloadOperation.delegate = self
        downloadOperation.name = "Drive Download File"

        let uploadOperation = APIUploadFileOperation(courseId: courseId, termId: termId, shareOptions: shareOptions)
        uploadOperation.delegate = self
        uploadOperation.shouldDismissTransferView = true
        uploadOperation.name = "API Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            guard let srongSelf = self else {
                return
            }
            if !srongSelf.transferDidFail {
                self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: removeCacheOperation.file)
            }
        }

        removeCacheOperation.dependsOn(uploadOperation).dependsOn(downloadOperation)

        let operations = [downloadOperation, uploadOperation, removeCacheOperation]
        self.operations = operations
        return self.operations
    }

    func cancel() {
        for operation in operations {
            if operation.isExecuting {
                operation.cancel()
            }
        }
    }

    // MARK: Operation delegate

    func operationWillStartReportingProgress(_ operation: Operation?) {
        delegate?.transfer(self, willStartReportingProgressForOperation: operation)
    }

    func operationWillStopReportingProgress(_ operation: Operation?) {
        delegate?.transfer(self, willStopReportingProgressForOperation: operation)
    }

    internal func operation(_ operation: Operation?, didFailWithErrorMessage message: String) {
        transferDidFail = true
        delegate?.transfer(self, didFailExecuting: operation, errorMessage: message)
    }

    func operationDidCancel(operation: Operation?) {
        delegate?.transfer(self, didCancelExecuting: operation)
    }

    internal func operation(_ operation: Operation?, didProceedWithProgress progress: Float, bytesProceeded: String, totalSize: String) {
        if operation is DriveDownloadFileOperation {
            downloadProgress = progress
        } else if operation is APIUploadFileOperation {
            uploadProgress = progress
        }
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }

}
