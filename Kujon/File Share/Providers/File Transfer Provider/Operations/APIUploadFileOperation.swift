//
//  APIUploadFileOperation.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

protocol APIUploadFileOperationDataProvider {
    var localFileURL: URL? { get }
    var contentType: String { get }
    var shareOptions: ShareOptions? { get }
}

class APIUploadFileOperation: AsyncOperation, CallbackOperation {
    internal var localFileURL: URL?
    private var contentType: String
    internal var file: APIFile?
    internal weak var delegate: OperationDelegate?
    private let api = APIUploadProvider.shared

    private let courseId: String
    private let termId: String
    private var shareOptions: ShareOptions?
    internal var shouldDismissTransferView: Bool = false


    internal init(localFileURL: URL? = nil, contentType:String = MIMEType.binary.rawValue, courseId:String, termId:String, shareOptions: ShareOptions?) {
        self.localFileURL = localFileURL
        self.contentType = contentType
        self.courseId = courseId
        self.termId = termId
        self.shareOptions = shareOptions
        super.init()
    }

    override internal func main() {
        super.main()

        NSlogManager.showLog("## Start operation: \(name ?? "none")")
        if let dependentDownloadOperation = dependencies
            .filter({ $0 is APIUploadFileOperationDataProvider })
            .first as? APIUploadFileOperationDataProvider {
            localFileURL = dependentDownloadOperation.localFileURL
            contentType = dependentDownloadOperation.contentType
            if shareOptions == nil {
                shareOptions = dependentDownloadOperation.shareOptions
            }
        }

        guard
            let localFileURL = localFileURL,
            let shareOptions = shareOptions,
            let file = APIFile(localFileURL: localFileURL, courseId: courseId, termId: termId, shareOptions: shareOptions, contentType: contentType)
             else {
                NSlogManager.showLog("Operation \(name ?? "none") is not performed intentionally")
                state = .finished
                return
        }
        self.file = file

        guard file.fileSizeInBytes <= UInt64(Constants.maxAPIFileSizeInBytes) else {
            delegate?.operation(self, didFailWithErrorMessage: StringHolder.fileToLargeForAPIUpload)
            state = .finished
            return
        }

        guard let _ = try? Data.init(contentsOf: localFileURL) else {
            delegate?.operation(self, didFailWithErrorMessage: StringHolder.fileNotFound)
            return
        }

        if state == .cancelled {
            delegate?.operationDidCancel(operation: self)
            state = .finished
            return
        }

        api.startUpload(file: file, shareOptions: shareOptions, successHandler: { [weak self] uploadedFiles in

            if self?.state == .cancelled {
                self?.delegate?.operationDidCancel(operation: self)
                self?.state = .finished
                return
            }
            if let uploadedFile = uploadedFiles.first {
                self?.file?.fileId = uploadedFile.fileId
                self?.file?.shareOptions = uploadedFile.shareOptions
            }
            self?.state = .finished
            if let strongSelf = self, strongSelf.shouldDismissTransferView == true {
                self?.delegate?.operationWillStopReportingProgress(self)
            }

            }, failureHandler: { [weak self] message in
                self?.delegate?.operation(self, didFailWithErrorMessage:message)
                self?.state = .finished

            }, progressUpdateHandler: { [weak self] progress, totalBytesProceededFormatted, totalSizeFormatted, bytesProceeded in
                self?.delegate?.operation(self, didProceedWithProgress: progress, bytesProceeded: totalBytesProceededFormatted, totalSize: totalSizeFormatted)
        })

    }

    override internal func cancel() {
        super.cancel()
        if let file = file {
            api.cancelUpload(file: file)
        }
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }

}

extension APIUploadFileOperation: RemoveCachedFileDataProvider {
    
    internal var localFile: APIFile? {
        return file
    }
}


