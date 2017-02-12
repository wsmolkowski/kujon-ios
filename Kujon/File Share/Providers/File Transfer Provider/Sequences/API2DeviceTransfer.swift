//
//  API2DeviceTransfer.swift
//  Kujon
//
//  Created by Adam on 10.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class API2DeviceTransfer: Transferable, OperationDelegate {

    private let file: APIFile

    private var transferProgress: Float = 0.0
    internal var type: TransferType = .download

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?

    init(file: APIFile) {
        self.file = file
    }

    func createOperations() -> [Operation] {

        let apiDownloadOperation = APIDownloadFileOperation(file: file)
        apiDownloadOperation.delegate = self
        apiDownloadOperation.name = "API Download File"
        apiDownloadOperation.completionBlock = { [weak self] in
            if !apiDownloadOperation.didFail {
                self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: apiDownloadOperation.file)
            }
        }

        let operations = [apiDownloadOperation]
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
        transferProgress = progress
        delegate?.transfer(self, didProceedWithProgress: transferProgress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }
    
}
