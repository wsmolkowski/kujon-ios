//
//  API2DriveTransfer
//  Kujon
//
//  Created by Adam on 22.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class API2DriveTransfer: Transferable, OperationDelegate {

    private let file: APIFile
    private let destinationFolder: GTLRDrive_File

    private var downloadProgress: Float = 0.0
    private var uploadProgress: Float = 0.0
    private var transferProgress: Float { return downloadProgress / 2.0 + uploadProgress / 2.0 }

    internal var operations: [Operation] = []
    internal weak var delegate: TransferDelegate?

    init(file: APIFile, destinationFolder: GTLRDrive_File) {
        self.file = file
        self.destinationFolder = destinationFolder
    }

    func createOperations() -> [Operation] {

        let apiDownloadOperation = APIDownloadFileOperation(file: file)
        apiDownloadOperation.delegate = self
        apiDownloadOperation.name = "API Download File"

        let driveUploadOperation = DriveUploadFileOperation(destinationFolder:destinationFolder)
        driveUploadOperation.delegate = self
        driveUploadOperation.name = "Drive Upload File"

        let removeCacheOperation = RemoveCachedFileOperation()
        removeCacheOperation.delegate = self
        removeCacheOperation.name = "Remove Cached File"
        removeCacheOperation.completionBlock = { [weak self] in
            self?.delegate?.transfer(self, didFinishWithSuccessAndReturn: removeCacheOperation.file)
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
