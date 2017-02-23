//
//  SharedFilesViewController.swift
//  Kujon
//
//  Created by Adam on 07.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import MobileCoreServices

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
    internal var courseName: String = ""

    private lazy var icloudProvider: ICloudDriveProvider = {
        return ICloudDriveProvider(with: self)
    }()
    private var fileListProvider = APIFileListProvider()
    private var presentedFiles: [APIFile] {
        guard let state = toolbarMenu?.state else {
            return []
        }
        return state == .allFiles ? allFiles : mineFiles
    }

    private var allFiles: [APIFile] = []
    private var mineFiles: [APIFile] {
        return allFiles.filter { file in
        if let fileSharedByMe = file.fileSharedByMe, fileSharedByMe == true {
            return true
        }
        return false
        }
    }
    private var courseStudentsCached: [SimpleUser]?
    private var sortKey: SortKey = .dateAddedDescending

    enum SortKey: Int {
        case fileNameAscending = 0
        case dateAddedDescending
        case ownerNameAscending
    }

    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fileListProvider.delegate = self
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SharedFilesViewController.backButtonDidTap),andTitle: courseName)
        addRefreshControl()
        configureNavigationBar()
        configureTableView()
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
        let sortButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sort-by-icon"), style: .plain, target: self, action: #selector(SharedFilesViewController.sortButtonDidTap))

        navigationItem.rightBarButtonItems = [addButtonItem!, sortButtonItem]
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

    // MARK: - Navigation

    internal func backButtonDidTap() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func refresh(_ refreshControl: KujonRefreshControl) {
        if refreshControl.refreshType == .userInitiated {
            fileListProvider.reload()
        }
        if let courseId = courseId, let termId = termId {
            fileListProvider.loadFileList(courseId: courseId, termId: termId)
        }
    }

    internal func addButtonDidTap() {
        presentAddOptions()
    }

    internal func sortButtonDidTap() {
        presentSortOptions()
    }

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

    // MARK: - ToolbarMenuControllerDelegate

    func toolbarMenuControllerDidSelectState(_ state: ToolbarMenuState) {
        tableView.reloadData()
    }

    // MARK: - APIFileListProviderDelegate

    func apliFileListProvider(_ provider: APIFileListProvider?, didLoadFileList files: [APIFile]) {
        allFiles = sortedFiles(files, withKey: sortKey)
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

    // MARK: - Controller actions

    private func presentAddOptions() {
        let addFileFromGoogleDrive: UIAlertAction = UIAlertAction(title: StringHolder.addFromGoogleDrive, style: .default) { [unowned self] _ in
            self.shareFilesFromGoogleDrive(assignToCourseId: self.courseId, andTermId: self.termId)
        }

        let addFileFromICloudDrive: UIAlertAction = UIAlertAction(title: StringHolder.addFromICloudDrive, style: .default) { [unowned self] _ in
            self.shareFilesFromICloudDrive(assignToCourseId: self.courseId, andTermId: self.termId)
        }

        let addPhotoFromPhotoGallery: UIAlertAction = UIAlertAction(title: StringHolder.addFromPhotoGallery, style: .default) { [weak self] _ in
            if let strongSelf = self {
                strongSelf.photoProvider.delegate = strongSelf
                strongSelf.photoProvider.presentImagePicker(parentController: strongSelf, courseStudentsCached: strongSelf.courseStudentsCached)
            }
        }
        presentActionSheet(actions: [addFileFromGoogleDrive, addFileFromICloudDrive, addPhotoFromPhotoGallery])
    }

    private func presentFileOptions(for file: APIFile) {
        let title = file.fileName
        var fileSize = file.fileSize ?? "0.00"
        if !fileSize.hasSuffix(StringHolder.megabytes_short) && !fileSize.hasSuffix(StringHolder.kilobytes_short) {
            fileSize += " " + StringHolder.megabytes_short
        }
        let description = StringHolder.fileSize + " " + fileSize

        let previewFileAction: UIAlertAction = UIAlertAction(title: StringHolder.showPreview, style: .default) { [unowned self] _ in
            self.previewAPIFile(file)
        }

        let showDetailsAction: UIAlertAction = UIAlertAction(title: StringHolder.showFileDetails, style: .default) { [unowned self] _ in
            let controller = FileDetailsController(file: file, courseName: self.courseName, courseId: self.courseId, termId: self.termId, courseStudents: self.courseStudentsCached)
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: nil)
        }

        let addToGoogleDriveAction: UIAlertAction = UIAlertAction(title: StringHolder.addToGoogleDrive, style: .default) { [unowned self] _ in
            self.addToGoogleDrive(file: file)
        }

        let addToICloudDriveAction: UIAlertAction = UIAlertAction(title: StringHolder.addToICloudDrive, style: .default) { [unowned self] _ in
            self.addToICloudDrive(file: file)
        }

        let deleteFileAction: UIAlertAction = UIAlertAction(title: StringHolder.delete, style: .destructive) { [unowned self] _ in
            self.deleteFileIfUserConfirms(file: file)
        }
        let hasDeletionRight = file.fileSharedByMe != nil && file.fileSharedByMe == true
        deleteFileAction.isEnabled = hasDeletionRight

        let actions = [previewFileAction, showDetailsAction, addToGoogleDriveAction, addToICloudDriveAction, deleteFileAction]
        presentActionSheet(actions: actions, title: title, message: description)
    }

    private func addToGoogleDrive(file: APIFile) {
        let driveContentsProvider = DriveFolderContentsProvider()
        let configuration = ChooseFolderConfiguration(inputFile: file)
        let driveBrowser = DriveBrowser(configuration: configuration, provider: driveContentsProvider, completionHandler: nil)
        let navigationController = UINavigationController(rootViewController: driveBrowser)
        present(navigationController, animated: true, completion: nil)
    }

    private func shareFilesFromGoogleDrive(assignToCourseId courseId:String, andTermId termId:String) {
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
            let transfer = Drive2APITransfer(file: file, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
            strongSelf.setupNewTransfer(transfer)
        }
        let driveBrowser = DriveBrowser(configuration:configuration, provider:driveContentsProvider, completionHandler:completion)
        let navigationController = UINavigationController(navigationBarClass: nil, toolbarClass: ShareToolbar.self)
        navigationController.setViewControllers([driveBrowser], animated: true)
        present(navigationController, animated: true, completion: nil)
    }

    private func addToICloudDrive(file: APIFile) {

        let transfer = API2ICloudDriveTransfer(file: file, parentViewController: self)
        setupNewTransfer(transfer)
        self.addButtonItem?.isEnabled = false
    }

    private func shareFilesFromICloudDrive(assignToCourseId courseId:String, andTermId termId:String) {
        let transfer = ICloudDrive2APITransfer(parentController: self, assignApiCourseId: courseId, termId: termId, courseStudentsCached: courseStudentsCached)
        setupNewTransfer(transfer)
        self.addButtonItem?.isEnabled = false
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
                strongSelf.tableView.reloadSections(IndexSet(integer:0), with: .fade)
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

    func previewAPIFile(_ file: APIFile) {
        let transfer = API2DeviceTransfer(file: file)
        setupNewTransfer(transfer)
    }

    private func previewLocalFile(url: URL) {
        UIApplication.shared.statusBarStyle = .default
        let previewController = UIDocumentInteractionController(url: url)
        previewController.delegate = self
        previewController.presentPreview(animated: true)
    }

    private func setupNewTransfer(_ transfer: Transferable) {
        let transferManager = FileTransferManager.shared
        transferManager.delegate = self
        transferManager.execute(transfer: transfer)
    }

    private func presentSortOptions() {
        let section = IndexSet(integer: 0)
        let imageKey = "image"

        let sortWithNameAction: UIAlertAction = UIAlertAction(title: StringHolder.name, style: .default) { [unowned self] _ in
            self.sortKey = .fileNameAscending
            self.allFiles = self.sortedFiles(self.allFiles, withKey: self.sortKey)
            self.tableView.reloadSections(section, with: .top)
        }
        let nameSortIcon = UIImage(named: "sort-by-name-icon")!
        sortWithNameAction.setValue(nameSortIcon.withRenderingMode(.alwaysOriginal), forKey: imageKey)

        let sortWithDateAction: UIAlertAction = UIAlertAction(title: StringHolder.date, style: .default) { [unowned self] _ in
            self.sortKey = .dateAddedDescending
            self.allFiles = self.sortedFiles(self.allFiles, withKey: self.sortKey)
            self.tableView.reloadSections(section, with: .top)
        }
        let dateSortIcon = UIImage(named: "sort-by-date-icon")!
        sortWithDateAction.setValue(dateSortIcon.withRenderingMode(.alwaysOriginal), forKey: imageKey)

        let sortWithOwnerAction: UIAlertAction = UIAlertAction(title: StringHolder.author, style: .default) { [unowned self] _ in
            self.sortKey = .ownerNameAscending
            self.allFiles = self.sortedFiles(self.allFiles, withKey: self.sortKey)
            self.tableView.reloadSections(section, with: .top)
        }
        let authorSortIcon = UIImage(named: "sort-by-author-icon")!
        sortWithOwnerAction.setValue(authorSortIcon.withRenderingMode(.alwaysOriginal), forKey: imageKey)
        presentActionSheet(actions: [sortWithNameAction, sortWithDateAction, sortWithOwnerAction], title: StringHolder.sortWith)
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

    // MARK: - FileTransferManagerDelegate

    func transfer(_ transfer: Transferable?, willStartReportingProgressForOperation operation: Operation?) {
        DispatchQueue.main.async {
            self.addTransferView(toParent: self.tableView, trackTransfer: transfer)
            self.addButtonItem?.isEnabled = false
        }
    }

    func transfer(_ transfer: Transferable?, willStopReportingProgressForOperation operation: Operation?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
        }
    }

    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.closeTransferView()
            strongSelf.addButtonItem?.isEnabled = true

            if transfer is API2DeviceTransfer {
                guard let file = file as? APIFile, let url = file.localFileURL else { return }
                strongSelf.updateModelWith(existingFile: file)
                if strongSelf.isViewInViewHierarchy {
                    strongSelf.previewLocalFile(url: url)
                }
                return
            }

            if transfer is API2ICloudDriveTransfer {
                if let file = file as? APIFile {
                    ToastView.showInParent(strongSelf.navigationController?.view, withText: StringHolder.fileHasBeenAddedToiCloudDriveMessage(fileName: file.fileName), forDuration: 2.0)
                }
                return
            }

            if let view = strongSelf.navigationController?.view,
                let file = file as? APIFile {
                strongSelf.updateController(newFile: file)
                ToastView.showInParent(view, withText: StringHolder.fileHasBeenSharedMessage(fileName: file.fileName), forDuration: 2.0)
            }
        }
    }

    func transfer(_ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
            self?.presentAlertWithMessage(errorMessage, title: StringHolder.errorAlertTitle)
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
        let transfer = Device2APITransfer(fileURL: fileURL, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
        setupNewTransfer(transfer)
        addTransferView(toParent: tableView, trackTransfer: transfer)
        self.addButtonItem?.isEnabled = false
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
        updateControllersFile(file, with: shareOptions)
    }

    func fileDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?) {
        if let courseStudents = courseStudents, self.courseStudentsCached == nil {
            self.courseStudentsCached = courseStudents
        }
    }

    // MARK: - UIDocumentInteractionControllerDelegate

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    // MARK: - Deinit

    deinit {
        FileTransferManager.shared.cancelAllTransfers()
    }

    // MARK: - Helpers

    private func updateController(newFile file: APIFile) {
        allFiles.append(file)
        allFiles = sortedFiles(allFiles, withKey: sortKey)
        folderIsEmpty = allFiles.isEmpty
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }

    private func updateControllersFile(_ file: APIFile, with shareOptions: ShareOptions ) {
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

    private func updateModelWith(existingFile file: APIFile) {
        for (index, originalfile) in allFiles.enumerated() {
            if let originalFileId = originalfile.fileId, let fileId = file.fileId, originalFileId == fileId {
                allFiles[index] = file
            }
        }
    }

    private func removeFileFromModel(_ fileToRemove: APIFile) {
        if let index = allFiles.index(of: fileToRemove) {
            allFiles.remove(at: index)
        }
    }

    private func sortedFiles(_ files: [APIFile], withKey sortKey: SortKey) -> [APIFile] {

        switch sortKey {
        case .fileNameAscending:
            return files.sorted { $0.fileName < $1.fileName }
        case .ownerNameAscending:
            return files.sorted { lhs, rhs in
                let lhsName = (lhs.lastName ?? "") + (lhs.firstName ?? "")
                let rhsName = (rhs.lastName ?? "") + (rhs.firstName ?? "")
                return lhsName < rhsName
            }
        case .dateAddedDescending:
            return files.sorted { lhs, rhs in
                guard let lhsDate = lhs.createdDate, let rhsDate = rhs.createdDate else {
                    return true
                }
                return rhsDate.isLessThanDate(lhsDate)
            }
        }
    }

}
