//
//  ICloudDriveProvider.swift
//  Kujon
//
//  Created by Adam on 17.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class ICloudDriveProvider: NSObject, UIDocumentPickerDelegate {

    typealias ICloudDriveProviderCompletionHandler = (URL) -> Void
    typealias ICloudDriveProviderCancelHandler = () -> Void

    private let parentViewController: UIViewController
    private let publicDocumentsType: String = "public.item"
    private var completionHandler: ICloudDriveProviderCompletionHandler?
    private var cancelHandler: ICloudDriveProviderCancelHandler?

    init(with parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
    }

    internal func uploadFile(url: URL, completion: @escaping ICloudDriveProviderCompletionHandler, cancel: @escaping ICloudDriveProviderCancelHandler) {
        completionHandler = completion
        cancelHandler = cancel
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let documentPicker = UIDocumentPickerViewController(url: url, in: .exportToService)
            documentPicker.delegate = strongSelf
            strongSelf.parentViewController.present(documentPicker, animated: true, completion: nil)
        }
    }

    internal func downloadFile(completion: @escaping ICloudDriveProviderCompletionHandler, cancel: @escaping ICloudDriveProviderCancelHandler) {
        completionHandler = completion
        cancelHandler = cancel
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }

            let documentPicker = UIDocumentPickerViewController(documentTypes: [strongSelf.publicDocumentsType], in: .import)
            documentPicker.delegate = strongSelf
            strongSelf.parentViewController.present(documentPicker, animated: true, completion: nil)
        }
    }


    // MARK: - UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let _ = url.startAccessingSecurityScopedResource()
        let coordinator = NSFileCoordinator()
        var error: NSError?

        coordinator.coordinate(readingItemAt: url, options: .forUploading, error: &error) { [weak self] coordinatedURL in
            var fileName = coordinatedURL.lastPathComponent
            var tempUrl = coordinatedURL
            if tempUrl.pathExtension == "zip" {
                tempUrl.deletePathExtension()
                let pathExtension = tempUrl.pathExtension
                if  pathExtension.contains("pages") || pathExtension.contains("numbers") || pathExtension.contains("key") {
                    fileName = tempUrl.lastPathComponent
                }
            }

            if let fileData = try? Data.init(contentsOf: coordinatedURL, options: Data.ReadingOptions.uncached),
                let cachedFileURL = URL.createURLForFileName(fileName, in: .cachesDirectory),
                let _ = try? fileData.write(to: cachedFileURL) {
                self?.completionHandler?(cachedFileURL)
            }
        }
        url.stopAccessingSecurityScopedResource()
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        cancelHandler?()
    }

}
