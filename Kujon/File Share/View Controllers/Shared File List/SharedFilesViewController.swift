//
//  SharedFilesViewController.swift
//  Kujon
//
//  Created by Adam on 07.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class SharedFilesViewController: UIViewController, APIFileListProviderDelegate, FileTransferManagerDelegate, TransferViewProviding, UITableViewDataSource, UITableViewDelegate, ToolbarMenuControllerDelegate, PhotoFileProviderDelegate, FileDetailsControllerDelegate {

    private let fileCellHeight: CGFloat = 50.0
    private let fileCellId: String = "fileCellId"
    private var spinner = SpinnerView()
    private var emptyFolderLabel: UILabel?
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
    private var courseStudents: [SimpleUser]?

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
        addEmptyFolderLabel(hidden:true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSpinner()
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

    private func addEmptyFolderLabel(hidden:Bool) {
        emptyFolderLabel = UILabel()
        emptyFolderLabel?.text = StringHolder.folderEmpty
        emptyFolderLabel?.textAlignment = .center
        tableView.backgroundView = emptyFolderLabel!
        emptyFolderLabel?.isHidden = hidden
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
                strongSelf.photoProvider.presentImagePicker(parentController: strongSelf)
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
        emptyFolderLabel?.isHidden = !presentedFiles.isEmpty
    }

    func onErrorOccurs(_ text: String) {
        refreshControl?.endRefreshing()
        presentAlertWithMessage(text, title: StringHolder.errorAlertTitle)
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
        presentUserOptions(for: file)
    }

    private func presentUserOptions(for file: APIFile) {
        let title = file.fileName
        let description = StringHolder.fileSize + " " + (file.fileSize ?? "0.00") + " " + StringHolder.megabytes_short

        let showDetails: UIAlertAction = UIAlertAction(title: StringHolder.showFileDetails, style: .default) { [unowned self] _ in
                let controller = FileDetailsController(file: file, courseId: self.courseId, termId: self.termId, courseStudents: self.courseStudents)
                controller.delegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                self.present(navigationController, animated: true, completion: nil)
        }

        let addToDriveAction: UIAlertAction = UIAlertAction(title: StringHolder.addToGoogleDrive, style: .default) { [unowned self] _ in
            self.addToDrive(file: file)
        }

        let deleteAction: UIAlertAction = UIAlertAction(title: StringHolder.delete, style: .destructive) { [unowned self] _ in
            self.deleteFile(file)
        }
        let hasDeletionRight = file.fileSharedByMe != nil && file.fileSharedByMe == true
        deleteAction.isEnabled = hasDeletionRight

        presentActionSheet(actions: [showDetails, addToDriveAction, deleteAction], title: title, message: description)
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
        let configuration = SelectFileConfiguration(courseId: courseId, termId: termId)
        let completion: DriveBrowserCompletionHandler = { file, shareOptions in
            let transferManager = FileTransferManager.shared
            transferManager.delegate = self
            let transfer = Drive2APITransfer(file: file, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
            transferManager.execute(transfer: transfer)
            DispatchQueue.main.async {
                self.addTransferView(toParent: self.tableView, trackTransfer: transfer)
                self.addButtonItem?.isEnabled = false
            }
        }
        let driveBrowser = DriveBrowser(configuration:configuration, provider:driveContentsProvider, completionHandler:completion)
        let navigationController = UINavigationController(navigationBarClass: nil, toolbarClass: ShareToolbar.self)
        navigationController.setViewControllers([driveBrowser], animated: true)
        present(navigationController, animated: true, completion: nil)
    }

    private func deleteFile(_ file: APIFile) {
        spinner.isHidden = false
        deletionProvider.deleteFile(file, successHandler: { [weak self] fileId in
            DispatchQueue.main.async { [weak self] in
                self?.spinner.isHidden = true
                self?.removeFileFromModel(file)
                self?.tableView.reloadData()
                if let view = self?.navigationController?.view {
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

    // MARK: FileTransferManagerDelegate

    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            self?.addButtonItem?.isEnabled = true
            if let view = self?.navigationController?.view,
                let file = file as? APIFile {
                self?.allFiles.append(file)
                self?.allFiles.sort { $0.fileName < $1.fileName }
                self?.tableView.reloadData()
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

    func photoFileProvider(_ provider: PhotoFileProvider?, didFinishWithPhotoFileURL fileURL: URL, shareOptions: ShareOptions) {
        let transferManager = FileTransferManager.shared
        transferManager.delegate = self
        let transfer = LocalFile2APITransfer(fileURL: fileURL, assignApiCourseId: courseId, termId: termId, shareOptions: shareOptions)
        transferManager.execute(transfer: transfer)
        DispatchQueue.main.async {
            self.addTransferView(toParent: self.tableView, trackTransfer: transfer)
            self.addButtonItem?.isEnabled = false
        }
    }

    func photoFileProviderDidCancel() {
        DispatchQueue.main.async { [weak self] in
            self?.addButtonItem?.isEnabled = true
        }
    }

    func photoFileProviderDidFailToDeliverPhoto() {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlertWithMessage(StringHolder.photoSaveErrorMessage, title: StringHolder.errorAlertTitle)
            self?.addButtonItem?.isEnabled = true
        }
    }

    func photoFileProviderWillPresentStudentsListForCourseIdAndTermId() -> (courseId: String, termId: String) {
        return (courseId: courseId, termId: termId)
    }

    // MARK: - FileDetailsControllerDelegate

    func fileDetailsController(_ controller: FileDetailsController?, didFinishWith shareOptions: ShareOptions, forFile file: APIFile, loadedForCache courseStudents: [SimpleUser]?) {
        if let courseStudents = courseStudents, self.courseStudents == nil {
            self.courseStudents = courseStudents
        }
        updateFile(file, shareOptions: shareOptions)
    }

    private func updateFile(_ file: APIFile, shareOptions: ShareOptions ) {
        for (index, originalfile) in allFiles.enumerated() {
            if let originalFileId = originalfile.fileId, let fileId = file.fileId, originalFileId == fileId {
                allFiles[index].shareOptions = file.shareOptions
                tableView.reloadData()
            }
        }
    }
    func fileDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?) {
        if let courseStudents = courseStudents, self.courseStudents == nil {
            self.courseStudents = courseStudents
        }
    }
}