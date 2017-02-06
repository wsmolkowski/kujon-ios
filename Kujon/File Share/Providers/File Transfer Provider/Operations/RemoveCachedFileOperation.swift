//
//  RemoveCachedFileOperation.swift
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation


protocol RemoveCachedFileDataProvider {
    var localFile: APIFile? { get }
}

class RemoveCachedFileOperation: Operation, CallbackOperation {
    internal var file: APIFile?
    internal weak var delegate: OperationDelegate?

    override internal func main() {
        super.main()

        NSlogManager.showLog("## Start operation: \(name ?? "none")")
        if let driveUploadFileOperation = dependencies
            .filter({ $0 is RemoveCachedFileDataProvider })
            .first as? RemoveCachedFileDataProvider {
            file = driveUploadFileOperation.localFile
        }

        guard let fileURL = file?.localFileURL else {
            NSlogManager.showLog("Operation \(name ?? "none") is not performed intentionally")
            return
        }

        do {
            try FileManager.default.removeItem(at: fileURL)
            file?.localFileURL = nil

        } catch {
            self.delegate?.operation(self, didFailWithErrorMessage: error.localizedDescription)
        }
    }
}
