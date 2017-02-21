//
//  FileTransferManager
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol FileTransferManagerDelegate: class {

    func transfer(_ transfer: Transferable?, willStartReportingProgressForOperation operation: Operation?)
    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?)
    func transfer(_ transfer: Transferable?, didCancelExecuting operation: Operation?)
    func transfer(_ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage: String)
    func transfer(_ transfer: Transferable?, didProceedWithProgress progress: Float, bytesProceededPerOperation bytesProceeded: String, totalSize: String)

}

class FileTransferManager: TransferDelegate {

    static let shared = FileTransferManager()
    private var queue: OperationQueue
    private var activeTransfers: [Transferable] = []
    internal weak var delegate: FileTransferManagerDelegate?

    init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
    }


    internal func execute(transfer: Transferable) {
        transfer.delegate = self
        activeTransfers.append(transfer)
        queue.addOperations(transfer.createOperations(), waitUntilFinished: false)
    }

    internal func cancelAllTransfers() {
        queue.cancelAllOperations()
    }

    internal func cancel(transfer: Transferable?) {
        transfer?.cancel()
    }

    // MARK: TransferDelegate

    func transfer(_ transfer: Transferable?, willStartReportingProgressForOperation operation: Operation?) {
        delegate?.transfer(transfer, willStartReportingProgressForOperation: operation)
    }

    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?) {
        let transfer = removeTransfer(transfer)
        delegate?.transfer(transfer, didFinishWithSuccessAndReturn: file)
    }

    func transfer(_ transfer: Transferable?, didCancelExecuting operation: Operation?) {
        let transfer = removeTransfer(transfer)
        delegate?.transfer(transfer, didCancelExecuting: operation)
    }

    func transfer(_ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage: String) {
        let transfer = removeTransfer(transfer)
        delegate?.transfer(transfer, didFailExecuting: operation, errorMessage: errorMessage)
    }

    func transfer(_ transfer: Transferable?, didProceedWithProgress progress: Float, bytesProceededPerOperation bytesProceeded: String, totalSize: String) {
        delegate?.transfer(transfer, didProceedWithProgress: progress, bytesProceededPerOperation: bytesProceeded, totalSize: totalSize)
    }

    // MARK: Helpers


    private func removeTransfer( _ transfer: Transferable?) -> Transferable? {
        if let transfer = transfer {
            for (index, activeTransfer) in activeTransfers.enumerated() {
                if transfer === activeTransfer {
                    return activeTransfers.remove(at: index)
                }
            }
        }
        return nil
    }


}
