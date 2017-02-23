//
//  DriveUploadFileOperation.swift
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol DriveUploadFileOperationDataProvider {
    var localFile: APIFile { get }
}

class DriveUploadFileOperation: AsyncOperation, CallbackOperation {
    internal var file: APIFile?
    private let destinationFolderId: String?
    private let drive = DriveManager.shared
    internal weak var delegate: OperationDelegate?
    internal var shouldDismissTransferView: Bool = false


    internal init(destinationFolder: GTLRDrive_File? = nil) {
        self.destinationFolderId = destinationFolder?.identifier ?? nil
        super.init()
    }

    override internal func main() {
        super.main()

        NSlogManager.showLog("## Start operation: \(name ?? "none")")
        if let dependentDownloadOperation = dependencies
            .filter({ $0 is DriveUploadFileOperationDataProvider })
            .first as? DriveUploadFileOperationDataProvider {
            file = dependentDownloadOperation.localFile
        }

        guard let fileURL = file?.localFileURL  else {
            NSlogManager.showLog("Operation \(name ?? "none") is not performed intentionally")
            state = .finished
            return
        }

        if state == .cancelled {
            delegate?.operationDidCancel(operation: self)
            state = .finished
            return
        }

        guard drive.isUserAuthorized else {
            delegate?.operation(self, didFailWithErrorMessage: StringHolder.userNotLoggedInToGoogleMessage)
            state = .finished
            return
        }

        do {
            try drive.uploadFile(fileURL: fileURL, destinationFolderId: destinationFolderId, success: { [weak self] _ in

                if self?.state == .cancelled {
                    self?.delegate?.operationDidCancel(operation: self)
                    self?.state = .finished
                    return
                } else {
                    self?.state = .finished
                    if let strongSelf = self, strongSelf.shouldDismissTransferView == true {
                        self?.delegate?.operationWillStopReportingProgress(self)
                    }
                }

                }, failure: { [weak self] message in
                    self?.delegate?.operation(self, didFailWithErrorMessage:message)
                    self?.state = .finished

                }, progressUpdateHandler: { [weak self] progress, totalBytesProceededFormatted, totalSizeFormatted in
                    self?.delegate?.operation(self, didProceedWithProgress: progress, bytesProceeded: totalBytesProceededFormatted, totalSize: totalSizeFormatted)

            })
        } catch {
            delegate?.operation(self, didFailWithErrorMessage:error.localizedDescription)
            state = .finished
        }

    }

    override internal func cancel() {
        super.cancel()

        if let localFileURL = file?.localFileURL {
            drive.cancelUpload(fileURL: localFileURL)
        }
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }


}

extension DriveUploadFileOperation: RemoveCachedFileDataProvider {
    
    internal var localFile: APIFile? {
        return file
    }
}
