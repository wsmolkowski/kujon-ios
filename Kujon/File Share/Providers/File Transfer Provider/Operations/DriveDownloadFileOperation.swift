//
//  DriveDownloadFileOperation.swift
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST


class DriveDownloadFileOperation: AsyncOperation, CallbackOperation {
    internal let inputFile: GTLRDrive_File
    internal var outputURL: URL?
    private let drive = DriveManager.shared
    internal weak var delegate: OperationDelegate?

    internal init(file: GTLRDrive_File) {
        self.inputFile = file
        super.init()
    }

    override internal func main() {
        super.main()

        NSlogManager.showLog("## Start operation: \(name ?? "none")")
        guard let cacheDirectory = FileManager.directoryURL(for: .cachesDirectory) else {
            state = .finished
            return
        }

        if state == .cancelled {
            delegate?.operationDidCancel(operation: self)
            state = .finished
            return
        }

        delegate?.operationWillStartReportingProgress(self)

        do {
            try drive.downloadFile(inputFile, toDirectory: cacheDirectory, success: { [weak self] downloadedFileURL in

                if self?.state == .cancelled {
                    self?.delegate?.operationDidCancel(operation: self)
                    self?.state = .finished
                    return
                }
                self?.outputURL = downloadedFileURL
                self?.state = .finished

                }, failure: { [weak self] message in
                    self?.delegate?.operation(self, didFailWithErrorMessage: message)
                    self?.state = .finished

                }, progressUpdateHandler: { [weak self] progress, totalBytesProceededFormatted, totalSizeFormatted in
                    self?.delegate?.operation(self, didProceedWithProgress: progress, bytesProceeded: totalBytesProceededFormatted, totalSize: totalSizeFormatted)
            })
            
        } catch {
            delegate?.operation(self, didFailWithErrorMessage: error.localizedDescription)
            state = .finished
        }

    }

    override internal func cancel() {
        super.cancel()
        drive.cancelDownload(file: inputFile)
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }

}


extension DriveDownloadFileOperation: APIUploadFileOperationDataProvider {
    internal var localFileURL: URL? { return outputURL }
    internal var contentType: String { return inputFile.mimeType ?? MIMEType.binary.rawValue }
    internal var shareOptions: ShareOptions? { return nil }
}
