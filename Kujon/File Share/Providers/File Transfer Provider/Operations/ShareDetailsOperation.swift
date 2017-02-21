//
//  ShareDetailsOperation.swift
//  Kujon
//
//  Created by Adam on 21.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

protocol ShareDetailsOperationDataProvider {

    var localFileURL: URL? { get }
    var contentType: String { get }
}


class ShareDetailsOperation: AsyncOperation, CallbackOperation, ShareDetailsControllerDelegate {

    fileprivate var options: ShareOptions?
    fileprivate var inputLocalFileURL: URL?
    fileprivate var inputContentType: String?

    private let courseId: String
    private let termId: String
    internal weak var delegate: OperationDelegate?
    private var shareController: ShareDetailsController?
    private let controller: UIViewController
    private var courseStudentsCached: [SimpleUser]?
    internal var shouldDismissTransferView: Bool = false



    init(parentController: UIViewController, courseId:String, termId:String, courseStudentsCached: [SimpleUser]?) {
        self.controller = parentController
        self.courseId = courseId
        self.termId = termId
        self.courseStudentsCached = courseStudentsCached
    }

    override internal func main() {
        super.main()

        NSlogManager.showLog("## Start operation: \(name ?? "none")")
        if let dependentDownloadOperation = dependencies
            .filter({ $0 is ShareDetailsOperationDataProvider })
            .first as? ShareDetailsOperationDataProvider {
            inputLocalFileURL = dependentDownloadOperation.localFileURL
            inputContentType = dependentDownloadOperation.contentType
        }

        guard let _ = inputLocalFileURL, let _ = inputContentType  else {
            NSlogManager.showLog("Operation \(name ?? "none") is not performed intentionally")
            state = .finished
            return
        }

        if state == .cancelled {
            delegate?.operationDidCancel(operation: self)
            state = .finished
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.presentShareOptionsAlert { shouldSelectUsers in

                if shouldSelectUsers {
                     DispatchQueue.main.async { [weak self] in
                        self?.presentShareDetailsController()
                    }
                    return
                }

                let shareOptions = ShareOptions(sharedWith: .all)
                self?.options = shareOptions
                self?.state = .finished
                self?.delegate?.operationWillStartReportingProgress(self)
            }
        }
        
    }

    override func cancel() {
        super.cancel()
        delegate?.operationDidCancel(operation: self)
        state = .finished
    }

    // MARK: ShareDetailsControllerDelegate

    func shareDetailsController(_ controller: ShareDetailsController?, didFinishWith shareOptions: ShareOptions, loadedForCache courseStudents: [SimpleUser]?) {
        DispatchQueue.main.async { [weak self] in
            self?.options = shareOptions
            self?.courseStudentsCached = nil
            self?.state = .finished
            self?.delegate?.operationWillStartReportingProgress(self)
        }
    }

    func shareDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.operationDidCancel(operation: self)
            self?.state = .finished
            self?.courseStudentsCached = nil
        }
    }

    // MARK: Flow Helpers

    private func presentShareOptionsAlert(completion: @escaping (Bool) -> Void) {
        let shareWithAllAction = UIAlertAction(title: StringHolder.shareWithAll_short, style: .default) { _ in
            let shouldSelectUsers = false
            completion(shouldSelectUsers)
        }
        let shareWithSelectedAction = UIAlertAction(title: StringHolder.shareWithSelected_short, style: .default) { _ in
            let shouldSelectUsers = true
            completion(shouldSelectUsers)
        }
        let alert = UIAlertController(title: StringHolder.shareFile, message: StringHolder.selectShareOption, preferredStyle: .alert)
        alert.addAction(shareWithAllAction)
        alert.addAction(shareWithSelectedAction)
        controller.present(alert, animated: true, completion: nil)
    }

    private func presentShareDetailsController() {
        let shareController = ShareDetailsController(courseId: courseId, termId: termId, courseStudentsCached: courseStudentsCached)
        shareController.delegate = self
        let navigationController = UINavigationController(rootViewController: shareController)
        controller.present(navigationController, animated: true, completion: nil)
    }


}


extension ShareDetailsOperation: APIUploadFileOperationDataProvider {

    internal var localFileURL: URL? { return inputLocalFileURL }

    internal var contentType: String { return inputContentType ?? MIMEType.binary.rawValue }

    internal var shareOptions: ShareOptions? { return options }

}
