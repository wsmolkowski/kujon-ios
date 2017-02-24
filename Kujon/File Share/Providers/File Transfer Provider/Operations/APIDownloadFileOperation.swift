//
//  APIDownloadFileOperation.swift
//  Kujon
//
//  Created by Adam on 22.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class APIDownloadFileOperation: AsyncOperation, CallbackOperation {
    internal var file: APIFile
    private let api = APIDownloadProvider.shared
    internal weak var delegate: OperationDelegate?
    internal var shouldDismissTransferView: Bool = false

    internal init(file: APIFile) {
        self.file = file
        super.init()
    }

    override internal func main() {
        super.main()
        NSlogManager.showLog("## Start operation: \(name ?? "none")")

        if state == .cancelled {
            delegate?.operationDidCancel(operation: self)
            state = .finished
            return
        }
        delegate?.operationWillStartReportingProgress(self)

        api.startDownload(file:file, successHandler: { [weak self] downloadedFileURL in

            if self?.state == .cancelled {
                self?.delegate?.operationDidCancel(operation: self)
                self?.state = .finished
                return
            }

            self?.file.localFileURL = downloadedFileURL
            self?.state = .finished
            if let strongSelf = self, strongSelf.shouldDismissTransferView == true {
                self?.delegate?.operationWillStopReportingProgress(self)
            }

            }, failureHandler: { [weak self] message in
                self?.state = .finished
                self?.delegate?.operation(self, didFailWithErrorMessage: message)

            }, progressUpdateHandler: { [weak self] progress, totalBytesProceededFormatted, totalSizeFormatted, bytesProceeded in
                self?.delegate?.operation(self, didProceedWithProgress: progress, bytesProceeded: totalBytesProceededFormatted, totalSize: totalSizeFormatted)
        })

    }

    override internal func cancel() {
        super.cancel()
        api.cancelDownload(file: file)
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }

}

extension APIDownloadFileOperation: DriveUploadFileOperationDataProvider {
    internal var localFile: APIFile {
        return file
    }
}
