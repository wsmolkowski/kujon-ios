//
//  PhotoFileProvider.swift
//  Kujon
//
//  Created by Adam on 04.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

protocol PhotoFileProviderDelegate: class {

    func photoFileProvider(_ provider: PhotoFileProvider?, didFinishWithPhotoFileURL fileURL: URL, shareOptions: ShareOptions)
    func photoFileProviderDidCancel()
    func photoFileProviderDidFailToDeliverPhoto()
    func photoFileProviderWillPresentStudentsListForCourseIdAndTermId() -> (courseId: String, termId: String)
}

enum PhotoFileProviderError: Error {
    case cannotConvertImageToJPEGRepresentation
    case cannotFindCachesDirectory
}

class PhotoFileProvider: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ShareDetailsControllerDelegate {

    private let imagePicker = UIImagePickerController()
    private var controller: UIViewController?
    private var shareWithAllAction: UIAlertAction?
    private var shareWithSelectedAction: UIAlertAction?
    internal weak var delegate: PhotoFileProviderDelegate?
    private var fileURL: URL?

    override init() {
        super.init()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }

    internal func presentImagePicker(parentController controller: UIViewController) {
        self.controller = controller
        self.controller?.present(imagePicker, animated: true, completion: nil)
    }


    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            controller?.dismiss(animated: true, completion: nil)
            delegate?.photoFileProviderDidFailToDeliverPhoto()
            return
        }
        controller?.dismiss(animated: true, completion: { [weak self] in
            self?.presentFileNameInputAlert(onShareWithAll: { [weak self] fileName in
                guard let url = try? self?.saveJPEGFromImage(image, withFileName: fileName), let fileURL = url else {
                    self?.delegate?.photoFileProviderDidFailToDeliverPhoto()
                    return
                }
                let shareOptions = ShareOptions(sharedWith: .all)
                self?.delegate?.photoFileProvider(self, didFinishWithPhotoFileURL: fileURL, shareOptions: shareOptions)


            }, onShareWithSelected: { fileName in
                guard
                    let fileURL = try? self?.saveJPEGFromImage(image, withFileName: fileName),
                    let courseIdAndTermId = self?.delegate?.photoFileProviderWillPresentStudentsListForCourseIdAndTermId() else {
                    self?.delegate?.photoFileProviderDidFailToDeliverPhoto()
                    return
                }
                self?.fileURL = fileURL
                self?.presentStudentsSelectionController(courseId: courseIdAndTermId.courseId, termId: courseIdAndTermId.termId)


            }, onCancel: { _ in
                self?.delegate?.photoFileProviderDidCancel()
            })
        })
    }

    private func saveJPEGFromImage(_ image: UIImage, withFileName fileName: String) throws -> URL {
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            throw PhotoFileProviderError.cannotConvertImageToJPEGRepresentation
        }
        let fileNameWithExtension = addFileExtensionIfNeeded(fileName: fileName)
        guard let fileURL = URL.createURLForFileName(fileNameWithExtension, in: .cachesDirectory) else {
            throw PhotoFileProviderError.cannotFindCachesDirectory
        }

        try imageData.write(to: fileURL, options: .atomic)
        return fileURL
    }

    private func addFileExtensionIfNeeded(fileName: String) -> String {
        let jpgSuffix = ".jpg"
        let jpgSuffixAlt = ".jpeg"
        if fileName.uppercased().hasSuffix(jpgSuffix.uppercased()) || fileName.uppercased().hasSuffix(jpgSuffixAlt.uppercased()) {
            return fileName
        }
        return fileName + jpgSuffix
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller?.dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.photoFileProviderDidCancel()
        })
    }

    private func presentFileNameInputAlert(onShareWithAll: @escaping (String) -> Void, onShareWithSelected: @escaping (String) -> Void, onCancel: @escaping (UIAlertAction) -> Void) {
        var inputTextFiled = UITextField()
        shareWithAllAction = UIAlertAction(title: StringHolder.shareWithAll, style: .default) { [weak self] action in
            if let inputText = inputTextFiled.text, !inputText.isEmpty {
                onShareWithAll(inputText)
            } else {
                self?.presentFileNameInputAlert(onShareWithAll: onShareWithAll, onShareWithSelected: onShareWithSelected, onCancel: onCancel)
            }
        }
        shareWithAllAction?.isEnabled = false

        shareWithSelectedAction = UIAlertAction(title: StringHolder.shareWithSelected, style: .default) { [weak self] action in
            if let inputText = inputTextFiled.text, !inputText.isEmpty {
                onShareWithSelected(inputText)
            } else {
                self?.presentFileNameInputAlert(onShareWithAll: onShareWithAll, onShareWithSelected: onShareWithSelected, onCancel: onCancel)
            }
        }
        shareWithSelectedAction?.isEnabled = false

        let cancelAction = UIAlertAction(title: StringHolder.cancel, style: .destructive, handler: onCancel)

        let alert = UIAlertController(title: StringHolder.sharePhoto, message: StringHolder.enterFileNameForPhoto, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            inputTextFiled = textField
            inputTextFiled.placeholder = StringHolder.fileNamePlaceholder
            inputTextFiled.clearButtonMode = .whileEditing
            inputTextFiled.addTarget(self, action: #selector(PhotoFileProvider.inputTextFiledDidChange(_:)), for: .editingChanged)
        })
        alert.addAction(shareWithAllAction!)
        alert.addAction(shareWithSelectedAction!)
        alert.addAction(cancelAction)

        controller?.present(alert, animated: true, completion: nil)
    }

    internal func inputTextFiledDidChange(_ textField: UITextField) {
        let shareActionsEnabled = textField.text != nil && textField.text?.isEmpty == false
        shareWithAllAction?.isEnabled = shareActionsEnabled
        shareWithSelectedAction?.isEnabled = shareActionsEnabled
    }

    private func presentStudentsSelectionController(courseId: String, termId: String) {
        let studentsController = ShareDetailsController(courseId: courseId, termId: termId)
        studentsController.delegate = self
        let navigationController = UINavigationController(rootViewController: studentsController)
        controller?.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - ShareDetailsControllerDelegate

    func shareDetailsController(_ controller: ShareDetailsController?, didFinishWith shareOptions: ShareOptions) {
        guard let fileURL = fileURL else {
            delegate?.photoFileProviderDidFailToDeliverPhoto()
            return
        }
        delegate?.photoFileProvider(self, didFinishWithPhotoFileURL: fileURL, shareOptions: shareOptions)
    }

    func shareDetailsControllerDidCancel() {
        delegate?.photoFileProviderDidCancel()
    }

}
