//
//  SharedFilesViewController.swift
//  Kujon
//
//  Created by Adam on 07.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class SharedFilesViewController: UIViewController, APIFileListProviderDelegate, FileTransferManagerDelegate, TransferViewProviding, UITableViewDataSource, UITableViewDelegate, ToolbarMenuControllerDelegate, PhotoFileProviderDelegate, FileDetailsControllerDelegate, UIDocumentInteractionControllerDelegate {

    private let fileCellHeight: CGFloat = 50.0
    private let fileCellId: String = "fileCellId"
    private var spinner = SpinnerView()
    private var emptyFolderView: UIView?
    private var folderIsEmpty: Bool = false {
        didSet {
            emptyFolderView?.isHidden = !folderIsEmpty
        }
    }
    private var actionButton: UIBarButtonItem!

    internal var courseId: String!
    internal var termId: String!
    private let deletionProvider = APIDeletionProvider()
    internal var transferView: TransferView?
    private let toolbarMenuSegueId = "toolbarMenuEmbed"
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var tableView: UITableView!
    private weak var toolbarMenu: ToolbarMenuController?
    private lazy var photoProvider: PhotoFileProvider = PhotoFileProvider()
    private var addButtonItem: UIBarButtonItem?
    @IBOutlet weak var courseNameLabel: UILabel!
    internal var courseName: String = ""

    private var fileListProvider = APIFileListProvider()
    private var presentedFiles: [APIFile] {
        guard let state = toolbarMenu?.state else {
            return []
        }
        return state == .allFiles ? allFiles : mineFiles
    }

    private var allFiles: [APIFile] = []
    private var mineFiles: [APIFile] { return allFiles.filter { file in
        if let fileSharedByMe = file.fileSharedByMe, fileSharedByMe == true {
            return true
        }
        return false
        }
    }
    private var courseStudentsCached: [SimpleUser]?
    private var cachedFiles: [URL] = []


    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fileListProvider.delegate = self
        if let courseId = courseId, let termId = termId {
            fileListProvider.loadFileList(courseId: courseId, termId: termId)
        }
        title = StringHolder.fileShareTitle
        addRefreshControl()
        configureNavigationBar()
        configureTableView()
        courseNameLabel.text = courseName
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSpinner()
        if tableView.backgroundView == nil {
            addEmptyFolderView(hidden: true)
        }
        if self.isBeingPresented || self.isMovingToParentViewController {
            (refreshControl as? KujonRefreshControl)?.beginRefreshingProgrammatically()
        }
    }

    func refresh(_ refreshControl: KujonRefreshControl) {
        if refreshControl.refreshType == .userInitiated {
            fileListProvider.reload()
        }
        if let courseId = courseId, let termId = termId {
            fileListProvider.loadFileList(courseId: courseId, termId: termId)
        }
    }

    private func addRefreshControl() {
        refreshControl = KujonRefreshControl()
        refreshControl?.addTarget(self, action: #selector(RefreshingTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SharedFilesViewController.addButtonDidTap))
        navigationItem.rightBarButtonItem = addButtonItem
    }

    internal func addButtonDidTap() {
        presentAddOptions()
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "SharedFileCell", bundle: nil), forCellReuseIdentifier: fileCellId)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0

        tableView.separatorStyle = .none
        tableView.backgroundColor = .greyBackgroundColor()
    }

    private func addEmptyFolderView(hidden:Bool) {
        emptyFolderView = EmptyStateView.noFilesView(parentBounds: tableView.bounds)
        emptyFolderView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        tableView.backgroundView = emptyFolderView!
        emptyFolderView?.isHidden = hidden
    }

    private func addSpinner() {
        let spinnerSize: CGFloat = 50.0
        let correction: CGFloat = spinnerSize / 2.0
        spinner.frame.origin = CGPoint(x: view.bounds.midX - correction, y: view.bounds.midY - correction)
        spinner.frame.size = CGSize(width: spinnerSize, height: spinnerSize)
        navigationController?.view.addSubview(spinner)
        spinner.isHidden = true
    }

    private func presentAddOptions() {
        let addFileFromGoogleDrive: UIAlertAction = UIAlertAction(title: StringHolder.addFromGoogleDrive, style: .default) { [unowned self] _ in
            self.addFilesFromDriveToKujon(assignToCourseId: self.courseId, andTermId: self.termId)
        }

        let addPhotoFromPhotoGallery: UIAlertAction = UIAlertAction(title: StringHolder.addFromPhotoGallery, style: .default) { [weak self] _ in
            if let strongSelf = self {
                strongSelf.photoProvider.delegate = strongSelf
                strongSelf.photoProvider.presentImagePicker(parentController: strongSelf, courseStudentsCached: strongSelf.courseStudentsCached)
            }
        }
        presentActionSheet(actions: [addFileFromGoogleDrive, addPhotoFromPhotoGallery])
    }

    // MARK: - ToolbarMenuControllerDelegate

    func toolbarMenuControllerDidSelectState(_ state: ToolbarMenuState) {
        tableView.reloadData()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toolbarMenuSegueId {
            let toolbarController = segue.destination as! ToolbarMenuController
            toolbarController.delegate = self
            toolbarMenu = toolbarController
        }
    }

    internal func dismissFolderContents(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }

    // MARK: - APIFileListProviderDelegate

    func apliFileListProvider(_ provider: APIFileListProvider?, didLoadFileList files: [APIFile]) {
        allFiles = files.sorted { $0.fileName < $1.fileName }
        toolbarMenu?.reset()
        refreshControl?.endRefreshing()
        tableView.reloadData()
        folderIsEmpty = presentedFiles.isEmpty
    }

    func onErrorOccurs(_ text: String) {
        folderIsEmpty = false

        refreshControl?.endRefreshing()
        presentAlertWithMessage(text, title: StringHolder.errorAlertTitle)
    }

    func onUsosDown() {
        folderIsEmpty = false
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.endRefreshing()
            guard let strongSelf = self else {
                return
            }
            self?.tableView.visibleCells.forEach { $0.isHidden = true }
            EmptyStateView.showUsosDownAlert(inParent: strongSelf.view)
        }
    }


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentedFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fileCellId, for: indexPath) as! SharedFileCell
        let file = presentedFiles[indexPath.row]
        let position = CellPositionType.cellPositionTypeForIndex(indexPath.row, in: presentedFiles as [AnyObject])
        cell.configure(with: file, cellPosition: position)
        return cell
    }

    // MARK: - Table view data delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = presentedFiles[indexPath.row]
        presentFileOptions(for: file)
    }

    private func presentFileOptions(for file: APIFile) {
        let title = file.fileName
        var fileSize = file.fileSize ?? "0.00"
        if !fileSize.hasSuffix(StringHolder.megabytes_short) && !fileSize.hasSuffix(StringHolder.kilobytes_short) {
            fileSize += " " + StringHolder.megabytes_short
        }
        let description = StringHolder.fileSize + " " + fileSize

        let previewFileAction: UIAlertAction = UIAlertAction(title: StringHolder.showPreview, style: .default) { [unowned self] _ in
            self.previewFile(file)
        }

        let showDetailsAction: UIAlertAction = UIAlertAction(title: StringHolder.showFileDetails, style: .default) { [unowned self] _ in
                let controller = FileDetailsController(file: file, courseId: self.courseId, termId: self.termId, courseStudents: self.courseStudentsCached)
                controller.delegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                self.present(navigationController, animated: true, completion: nil)
        }

        let addToDriveAction: UIAlertAction = UIAlertAction(title: StringHolder.addToGoogleDrive, style: .default) { [unowned self] _ in
            self.addToDrive(file: file)
        }

        let deleteFileAction: UIAlertAction = UIAlertAction(title: StringHolder.delete, style: .destructive) { [unowned self] _ in
            self.deleteFileIfUserConfirms(file: file)
        }
        let hasDeletionRight = file.fileSharedByMe != nil && file.fileSharedByMe == true
        deleteFileAction.isEnabled = hasDeletionRight

        let actions = [previewFileAction, showDetailsAction, addToDriveAction, deleteFileAction]
        presentActionSheet(actions: actions, title: title, message: description)
    }

    private func addToDrive(file: APIFile) {
        let driveContentsProvider = DriveFolderContentsProvider()
        let configuration = ChooseFolderConfiguration(inputFile: file)
        let driveBrowser = DriveBrowser(configuration: configuration, provider: driveContentsProvider, completionHandler: nil)
        let navigationController = UINavigationController(rootViewController: driveBrowser)
        present(navigationController, animated: true, completion: nil)
    }

    private func addFilesFromDriveToKujon(assignToCourseId courseId:String, andTermId termId:String) {
        let driveContentsProvider = DriveFolderContentsProvider()
        let configuration = SelectFileConfiguration(courseId: courseId, termId: termId, courseStudentsCached: courseStudentsCached)
        let completion: DriveBrowserCompletionHandler = { [weak self] file, shareOptions, courseStudentsCached in
            guard let strongSelf = self else {
                return
            }
            strongSelf.courseStudentsCached = courseStudentsCached
            guard
                let file = file,
                let shareOptions = shareOptions else {
                return
            }
            let transferManager = FileTransferManager.shared
            transferManager.delegate = strongSelf
            let transfer = Drive2APITransfer(file: file, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
            transferManager.execute(transfer: transfer)
            DispatchQueue.main.async {
                strongSelf.addTransferView(toParent: strongSelf.tableView, trackTransfer: transfer)
                strongSelf.addButtonItem?.isEnabled = false
            }
        }
        let driveBrowser = DriveBrowser(configuration:configuration, provider:driveContentsProvider, completionHandler:completion)
        let navigationController = UINavigationController(navigationBarClass: nil, toolbarClass: ShareToolbar.self)
        navigationController.setViewControllers([driveBrowser], animated: true)
        present(navigationController, animated: true, completion: nil)
    }

    private func deleteFileIfUserConfirms(file: APIFile) {
        let alert = UIAlertController(title: StringHolder.deleteFile, message: StringHolder.fileWillBeDeletedMessage(fileName: file.fileName), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringHolder.delete, style: .destructive, handler: { [weak self] _ in
            self?.deleteFile(file)
        }))
        alert.addAction(UIAlertAction(title: StringHolder.cancel, style: .cancel, handler: nil))
        parent?.present(alert, animated: true, completion: nil)
    }

    private func deleteFile(_ file: APIFile) {
        spinner.isHidden = false
        deletionProvider.deleteFile(file, successHandler: { [weak self] fileId in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.spinner.isHidden = true
                strongSelf.removeFileFromModel(file)
                strongSelf.folderIsEmpty = strongSelf.allFiles.isEmpty
                strongSelf.tableView.reloadData()
                if let view = strongSelf.navigationController?.view {
                    ToastView.showInParent(view, withText: StringHolder.fileHasBeenRemovedMessage(fileName: file.fileName), forDuration: 2.0)
                }
            }

        }) { [weak self] message in
            DispatchQueue.main.async { [weak self] in
                self?.spinner.isHidden = true
                self?.presentAlertWithMessage(message, title: StringHolder.errorAlertTitle)
            }
        }

    }

    private func removeFileFromModel(_ fileToRemove: APIFile) {
        for (index, file) in allFiles.enumerated() {
            if file == fileToRemove {
                allFiles.remove(at: index)
                return
            }
        }
    }

    // MARK: - FileTransferManagerDelegate

    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
            if  let strongSelf = self,
                let view = strongSelf.navigationController?.view,
                let file = file as? APIFile {
                strongSelf.allFiles.append(file)
                strongSelf.allFiles.sort { $0.fileName < $1.fileName }
                strongSelf.folderIsEmpty = strongSelf.allFiles.isEmpty
                strongSelf.tableView.reloadData()
                ToastView.showInParent(view, withText: StringHolder.fileHasBeenSharedMessage(fileName: file.fileName), forDuration: 2.0)
            }
        }
    }

    func transfer(_ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
            self?.presentAlertWithMessage(errorMessage, title: StringHolder.fileShare)
        }
    }

    func transfer(_ transfer: Transferable?, didCancelExecuting operation: Operation?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
            if let view = self?.navigationController?.view {
                ToastView.showInParent(view, withText: StringHolder.fileDownloadCancelled, forDuration: 2.0)
            }
        }
    }

    func transfer(_ transfer: Transferable?, didProceedWithProgress progress: Float, bytesProceededPerOperation bytesProceeded: String, totalSize: String) {
        DispatchQueue.main.async { [weak self] in
            self?.transferView?.update(progress: progress)
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustFloatingTransferView(scrollView)
        updateToolbarMenuAlpha(for: scrollView.contentOffset)
    }

    private func updateToolbarMenuAlpha(for offset: CGPoint) {
        let alpha: CGFloat = -offset.y / 85.0
        let alphaBounded: CGFloat = max(min(alpha, 1.0), 0)
        toolbarMenu?.view.alpha = 1.0 - alphaBounded
    }

    // MARK: - PhotoFileProviderDelegate

    func photoFileProvider(_ provider: PhotoFileProvider?, didFinishWithPhotoFileURL fileURL: URL, shareOptions: ShareOptions, loadedForCache courseStudents: [SimpleUser]?) {
        courseStudentsCached = courseStudents
        let transferManager = FileTransferManager.shared
        transferManager.delegate = self
        let transfer = LocalFile2APITransfer(fileURL: fileURL, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
        transferManager.execute(transfer: transfer)
        DispatchQueue.main.async {
            self.addTransferView(toParent: self.tableView, trackTransfer: transfer)
            self.addButtonItem?.isEnabled = false
        }
    }

    func photoFileProviderDidCancel(loadedForCache courseStudents: [SimpleUser]?) {
        courseStudentsCached = courseStudents
        DispatchQueue.main.async { [weak self] in
            self?.addButtonItem?.isEnabled = true
        }
    }

    func photoFileProviderDidFailToDeliverPhoto(loadedForCache courseStudents: [SimpleUser]?) {
        courseStudentsCached = courseStudents
        DispatchQueue.main.async { [weak self] in
            self?.presentAlertWithMessage(StringHolder.photoSaveErrorMessage, title: StringHolder.errorAlertTitle)
            self?.addButtonItem?.isEnabled = true
        }
    }

    func photoFileProviderWillPresentStudentsListForCourseIdAndTermId() -> (courseId: String, termId: String) {
        return (courseId: courseId, termId: termId)
    }

    // MARK: - FileDetailsControllerDelegate

    func fileDetailsController(_ controller: FileDetailsController?, didUpdateFile file: APIFile, with shareOptions: ShareOptions, loadedForCache courseStudents: [SimpleUser]?) {
        if let courseStudents = courseStudents, self.courseStudentsCached == nil {
            self.courseStudentsCached = courseStudents
        }
        updateFile(file, shareOptions: shareOptions)
    }

    private func updateFile(_ file: APIFile, shareOptions: ShareOptions ) {
        for (index, originalfile) in allFiles.enumerated() {
            if let originalFileId = originalfile.fileId, let fileId = file.fileId, originalFileId == fileId {
                var fileToUpdate = allFiles[index]
                fileToUpdate.shareOptions = shareOptions
                allFiles[index] = fileToUpdate
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        }
    }

    func fileDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?) {
        if let courseStudents = courseStudents, self.courseStudentsCached == nil {
            self.courseStudentsCached = courseStudents
        }
    }

    // MARK: - Document preview

    func previewFile(_ file: APIFile) {
        let downloadProvider = APIDownloadProvider.shared
        spinner.isHidden = false
        downloadProvider.startDownload(file: file, successHandler: { fileURL in
            DispatchQueue.main.async { [weak self] in
                self?.spinner.isHidden = true
                self?.cachedFiles.append(fileURL)
                let previewController = UIDocumentInteractionController(url: fileURL)
                previewController.delegate = self
                previewController.presentPreview(animated: true)
            }
        }, failureHandler: { message in
            DispatchQueue.main.async { [weak self] in
                self?.spinner.isHidden = true
                self?.presentAlertWithMessage(message, title: StringHolder.errorAlertTitle)
            }
        }, progressUpdateHandler: { _, _, _ in })

    }

    // MARK: - UIDocumentInteractionControllerDelegate

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        removeAllCachedFiles()
    }

    private func removeAllCachedFiles() {
        for cachedFileURL in cachedFiles {
            if let _ = try? cachedFileURL.checkPromisedItemIsReachable() {
                NSlogManager.showLog("Removing cached file: \(cachedFileURL.lastPathComponent)")
                try? FileManager.default.removeItem(at: cachedFileURL)
            }
        }
    }

    // MARK: - Deinit

    deinit {
        removeAllCachedFiles()
    }

}
