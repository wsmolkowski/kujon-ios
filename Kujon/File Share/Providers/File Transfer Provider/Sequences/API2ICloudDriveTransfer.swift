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
    private var uploadProgress: Float = 0.0
    private var transferProgress: Float { return downloadProgress / 2.0 + uploadProgress / 2.0 }
    internal var type: TransferType = .add

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?

    init(file: APIFile, parentViewController: UIViewController) {
        self.file = file
        self.parentViewController = parentViewController
    }

    func createOperations() -> [Operation] {


        self.operations = [ ]
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
        } else if operation is DriveUploadFileOperation {
            uploadProgress = progress
        }
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }
    
}
