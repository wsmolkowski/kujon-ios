//
//  ICloudDrive2APITransfer.swift
//  Kujon
//
//  Created by Adam on 21.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class ICloudDrive2APITransfer: Transferable, OperationDelegate {

    private let courseId: String
    private let termId: String
    private let shareOptions: ShareOptions
    private let parentController: UIViewController

    private var uploadProgress: Float = 0.0
    private var transferProgress: Float { return uploadProgress }
    internal var type: TransferType = .add

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?


    init(parentController: UIViewController, assignApiCourseId courseId:String, termId:String, shareOptions: ShareOptions) {
        self.parentController = parentController
        self.courseId = courseId
        self.termId = termId
        self.shareOptions = shareOptions
    }

    func createOperations() -> [Operation] {
        let downloadOperation = ICloudDriveDownloadOperation(parentController: parentController)
        downloadOperation.delegate = self
        downloadOperation.name = "ICloud Drive Download File"

        let uploadOperation = APIUploadFileOperation(courseId: courseId, termId: termId, shareOptions: shareOptions)
        uploadOperation.delegate = self
        uploadOperation.name = "API Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: removeCacheOperation.file)
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

    internal func operation(_ operation: Operation?, didFailWithErrorMessage message: String) {
        delegate?.transfer(self, didFailExecuting: operation, errorMessage: message)
    }

    func operationDidCancel(operation: Operation?) {
        delegate?.transfer(self, didCancelExecuting: operation)
    }

    internal func operation(_ operation: Operation?, didProceedWithProgress progress: Float, bytesProceeded: String, totalSize: String) {
        if operation is APIUploadFileOperation {
            uploadProgress = progress
        }
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }
    
}
