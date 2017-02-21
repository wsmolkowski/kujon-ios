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
    private let parentController: UIViewController
    private var courseStudentsCached: [SimpleUser]?

    private var uploadProgress: Float = 0.0
    private var transferProgress: Float { return uploadProgress }
    internal var type: TransferType = .add

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?


    init(parentController: UIViewController, assignApiCourseId courseId:String, termId:String, courseStudentsCached: [SimpleUser]?) {
        self.parentController = parentController
        self.courseId = courseId
        self.termId = termId
        self.courseStudentsCached = courseStudentsCached
    }

    func createOperations() -> [Operation] {
        let downloadOperation = ICloudDriveDownloadOperation(parentController: parentController)
        downloadOperation.delegate = self
        downloadOperation.name = "ICloud Drive Download File"

        let shareOperation = ShareDetailsOperation(parentController: parentController, courseId: courseId, termId: termId, courseStudentsCached: courseStudentsCached)
        shareOperation.delegate = self
        shareOperation.name = "Share Details Set Operation"

        let uploadOperation = APIUploadFileOperation(courseId: courseId, termId: termId, shareOptions: nil)
        uploadOperation.delegate = self
        uploadOperation.shouldDismissTransferView = true
        uploadOperation.name = "API Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: removeCacheOperation.file)
        }

        removeCacheOperation.dependsOn(uploadOperation).dependsOn(shareOperation).dependsOn(downloadOperation)

        let operations = [downloadOperation, shareOperation, uploadOperation, removeCacheOperation]
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
