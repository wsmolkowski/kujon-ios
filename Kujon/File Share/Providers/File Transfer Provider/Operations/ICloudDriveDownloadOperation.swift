//
//  ICloudDriveDownloadOperation.swift
//  Kujon
//
//  Created by Adam on 20.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation


class ICloudDriveDownloadOperation: AsyncOperation, CallbackOperation {
    private let parentController: UIViewController
    private let icloudProvider: ICloudDriveProvider
    internal weak var delegate: OperationDelegate?
    fileprivate var downloadedFileURL: URL?

    internal init(parentController: UIViewController) {
        self.parentController = parentController
        self.icloudProvider = ICloudDriveProvider(with: parentController)
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

        icloudProvider.downloadFile(completion: { [weak self] localFileURL in

            if self?.state == .cancelled {
                self?.delegate?.operationDidCancel(operation: self)
                self?.state = .finished
                return
            }

            self?.downloadedFileURL = localFileURL
            self?.state = .finished

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

extension ICloudDriveDownloadOperation: ShareDetailsOperationDataProvider {

    var localFileURL: URL? {
        return downloadedFileURL
    }

    var contentType: String {
        return MIMEType.binary.rawValue // TODO: map mime type
    }

}

