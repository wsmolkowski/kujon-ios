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
        print("documentPicker DID PICK")
            completionHandler?(url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("documentPicker CANCELLED")
        cancelHandler?()
    }

    deinit {
        print("documentPicker DEALLOC")
    }

}
