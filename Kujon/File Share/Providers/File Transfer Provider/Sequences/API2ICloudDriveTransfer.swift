//
//  API2ICloudDriveTransfer.swift
//  Kujon
//
//  Created by Adam on 17.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class API2ICloudDriveTransfer: Transferable, OperationDelegate {

    private let file: APIFile
    private let parentViewController: UIViewController

    private var downloadProgress: Float = 0.0
    private var transferProgress: Float { return downloadProgress }
    internal var type: TransferType = .download

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?

    init(file: APIFile, parentViewController: UIViewController) {
        self.file = file
        self.parentViewController = parentViewController
    }

    func createOperations() -> [Operation] {

        let apiDownloadOperation = APIDownloadFileOperation(file: file)
        apiDownloadOperation.delegate = self
        apiDownloadOperation.name = "API Download File"

        let driveUploadOperation = ICloudDriveUploadOperation(parentController: parentViewController)
        driveUploadOperation.delegate = self
        driveUploadOperation.name = "iCloud Drive Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: nil)
        }

        removeCacheOperation.dependsOn(driveUploadOperation).dependsOn(apiDownloadOperation)

        let operations = [apiDownloadOperation, driveUploadOperation, removeCacheOperation]
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
        if operation is APIDownloadFileOperation {
            downloadProgress = progress
        }
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }
    
}
