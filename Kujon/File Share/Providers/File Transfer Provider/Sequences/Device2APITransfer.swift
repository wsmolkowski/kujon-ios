//
//  LocalFile2APITransfer.swift
//  Kujon
//
//  Created by Adam on 05.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation


class Device2APITransfer: Transferable, OperationDelegate {

    private let fileURL: URL
    private let courseId: String
    private let termId: String
    private let shareOptions: ShareOptions

    private var transferProgress: Float = 0.0
    internal var type: TransferType = .add

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?


    init(fileURL: URL, assignApiCourseId courseId:String, termId:String, shareOptions: ShareOptions) {
        self.fileURL = fileURL
        self.courseId = courseId
        self.termId = termId
        self.shareOptions = shareOptions
    }

    func createOperations() -> [Operation] {

        let uploadOperation = APIUploadFileOperation(localFileURL: fileURL, contentType: MIMEType.imageJPG.rawValue, courseId: courseId, termId: termId, shareOptions: shareOptions)
        uploadOperation.delegate = self
        uploadOperation.name = "API Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: removeCacheOperation.file)
        }

        removeCacheOperation.dependsOn(uploadOperation)

        let operations = [uploadOperation, removeCacheOperation]
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

    internal func operation(_ operation: Operation?, didFailWithErrorMessage message: String) {
        delegate?.transfer(self, didFailExecuting: operation, errorMessage: message)
    }

    func operationDidCancel(operation: Operation?) {
        delegate?.transfer(self, didCancelExecuting: operation)
    }

    internal func operation(_ operation: Operation?, didProceedWithProgress progress: Float, bytesProceeded: String, totalSize: String) {
        if operation is APIUploadFileOperation {
            transferProgress = progress
        }
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }
    
}
