//
//  ICloudDriveUploadOperation.swift
//  Kujon
//
//  Created by Adam on 21.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class ICloudDriveUploadOperation: AsyncOperation, CallbackOperation {
    internal var file: APIFile?
    internal weak var delegate: OperationDelegate?
    private let icloudProvider: ICloudDriveProvider
    internal var shouldDismissTransferView: Bool = false

    internal init(parentController: UIViewController) {
        self.icloudProvider = ICloudDriveProvider(with: parentController)
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

        icloudProvider.uploadFile(url: fileURL, completion: { [weak self] url in

            self?.state = .finished
            if let strongSelf = self, strongSelf.shouldDismissTransferView == true {
                self?.delegate?.operationWillStopReportingProgress(self)
            }

        }, cancel: { [weak self] in
            self?.delegate?.operationDidCancel(operation: self)
            self?.state = .finished
        })

    }

    override internal func cancel() {
        super.cancel()
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }

}

extension ICloudDriveUploadOperation: RemoveCachedFileDataProvider {

    internal var localFile: APIFile? {
        return file
    }
}
