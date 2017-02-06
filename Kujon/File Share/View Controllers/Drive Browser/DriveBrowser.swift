//
//  DriveBrowser
//  Kujon
//
//  Created by Adam on 02.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

typealias DriveBrowserCompletionHandler = (GTLRDrive_File, ShareOptions) -> Void

class DriveBrowser: UITableViewController, FolderContentsProvidingDelegate, FileTransferManagerDelegate, StudentsSelectionTableViewControllerDelegate, TransferViewProviding, ShareToolbarDelegate {

    private enum SectionsMap: Int {
        case folders = 0
        case files

        static func sectionForIndex(_ index:Int) -> SectionsMap {
            if let section = SectionsMap(rawValue: index) {
                return section
            }
            fatalError("Invalid section index")
        }
    }

    private let itemHeaderHeight: CGFloat = 50.0
    private let itemCellId: String = "itemCellId"
    private let sectionsCount: Int = 2
    private var spinner = SpinnerView()
    private var emptyFolderLabel: UILabel?
    internal var transferView: TransferView?

    internal let configuration: DriveBrowserConfigurable
    private var provider: FolderContentsProviding
    internal let completionHandler: DriveBrowserCompletionHandler?
    internal var contents: FolderContents?

    internal var selectedItem: SelectedItem? {
        didSet {
            navigationController?.setToolbarHidden(selectedItem == nil, animated: true)
         }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }


    // MARK: - Initial section

    init(folder: GTLRDrive_File? = nil, configuration: DriveBrowserConfigurable, provider: FolderContentsProviding, completionHandler: DriveBrowserCompletionHandler?) {

        self.provider = provider
        self.configuration = configuration
        self.completionHandler = completionHandler
        super.init(style: .plain)

        self.provider.delegate = self
        self.provider.cache = FolderContentsCache.shared
        if let folder = folder {
            provider.loadContents(folder: folder)
            title = folder.name ?? StringHolder.defaultFolderContentsTitle
            return
        }
        provider.loadContentsForRootFolder()
        title = StringHolder.rootFolderName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureToolbar()
        configureTableView()
        addRefreshControl()
        addEmptyFolderLabel(hidden:true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default

        if let selectFileConfiguration = configuration as? SelectFileConfiguration {
            updateControllerOnFolderChange(selectFileConfiguration)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSpinner()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    private func updateControllerOnFolderChange(_ configuration: SelectFileConfiguration) {
        selectedItem = configuration.selectedItem
        tableView.reloadData()
        if let toolbar = navigationController?.toolbar as? ShareToolbar {
            toolbar.toolbarDelegate = self
            toolbar.updateTitle()
        }
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.kujonBlueColor()
        navigationController?.navigationBar.isTranslucent = false

        if let leftNavigationBarButton = configuration.leftNavigationBarButton {
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftNavigationBarButton.title, style: UIBarButtonItemStyle.done, target: self, action: #selector(DriveBrowser.leftNavigationBarButtonDidTap))
        }

        if let rightNavigationBarButton = configuration.rightNavigationBarButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightNavigationBarButton.title, style: UIBarButtonItemStyle.done, target: self, action: #selector(DriveBrowser.rightNavigationBarButtonDidTap))
        }
    }

    private func configureToolbar() {

        guard configuration.mode == .selectFile else {
            return
        }

        navigationController?.toolbar.barTintColor = UIColor.kujonBlueColor()
        navigationController?.toolbar.tintColor = UIColor.white
        navigationController?.toolbar.isTranslucent = true

        let buttonAttributes: [String : Any] = [
            NSFontAttributeName: UIFont.kjnFontLatoBold(size: 19.0)!,
            NSForegroundColorAttributeName: UIColor.white
        ]
        let leftActionButton = UIBarButtonItem(title: StringHolder.shareWithAll_short, style: .plain, target: self, action: #selector(DriveBrowser.leftToolbarButtonDidTap))
        leftActionButton.setTitleTextAttributes(buttonAttributes, for: .normal)

        let rightActionButton = UIBarButtonItem(title: StringHolder.shareWithSelected_short, style: .plain, target: self, action: #selector(DriveBrowser.rightToolbarButtonDidTap))
        rightActionButton.setTitleTextAttributes(buttonAttributes, for: .normal)

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items: [UIBarButtonItem] = [flexibleSpace, leftActionButton, flexibleSpace, rightActionButton, flexibleSpace ]
        setToolbarItems(items, animated: false)
    }

    internal func leftNavigationBarButtonDidTap() {
        configuration.leftNavigationBarButton?.action(self)
    }

    internal func rightNavigationBarButtonDidTap() {
        configuration.rightNavigationBarButton?.action(self)
    }

    internal func leftToolbarButtonDidTap() {
        dismissBrowser { [weak self] in
            if let selectedItem = self?.selectedItem {
                let shareOptions = ShareOptions(sharedWith: .all)
                self?.completionHandler?(selectedItem.file, shareOptions)
            }
        }
    }

    internal func rightToolbarButtonDidTap() {
        if let configuration = configuration as? SelectFileConfiguration,
            let courseId = configuration.courseId, let termId = configuration.termId {
            let controller = StudentsSelectionTableViewController(courseId: courseId, termId: termId)
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            present(navigationController, animated: true, completion: nil)
        }
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "DriveItemCell", bundle: nil), forCellReuseIdentifier: itemCellId)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.driveBackgroundColor()
    }

    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.blackWithAlpha(alpha: 0.6)
        refreshControl?.attributedTitle = StringHolder.refresh.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 11)!, color: UIColor.blackWithAlpha())
        refreshControl?.addTarget(self, action: #selector(DriveBrowser.refresh), for: UIControlEvents.valueChanged)
    }

    private func addSpinner() {
        let spinnerSize: CGFloat = 50.0
        let correction: CGFloat = spinnerSize / 2.0
        spinner.frame.origin = CGPoint(x: view.bounds.midX - correction, y: view.bounds.midY - correction)
        spinner.frame.size = CGSize(width: spinnerSize, height: spinnerSize)
        navigationController?.view.addSubview(spinner)
        updateSpinnerState()
    }

    private func updateSpinnerState() {
        spinner.isHidden = !provider.isFetching
    }

    internal func refresh() {
        provider.cache?.clearCache()
        guard let contents = contents  else {
            return
        }
        provider.loadContents(folder:contents.currentFolder)
    }

    internal func dismissBrowser(completion: (() -> Void)? = nil) {
        provider.cache?.clearCache()
        provider.cache = nil
        dismiss(animated: true, completion: completion)
    }

    private func addEmptyFolderLabel(hidden:Bool) {
        emptyFolderLabel = UILabel()
        emptyFolderLabel?.text = StringHolder.folderEmpty
        emptyFolderLabel?.textAlignment = .center
        tableView.backgroundView = emptyFolderLabel!
        emptyFolderLabel?.isHidden = hidden
    }

    // MARK: - ShareToolbarDelegate

    func shareToolbarTitle() -> String {
        let fileName = selectedItem?.file.name ?? ""
        return StringHolder.share + " " + fileName
    }

    // MARK: - FolderContentsProvidingDelegate

    func folderContentsProvider(provider: FolderContentsProviding, didLoadContents contents: FolderContents, forFolderId folderId: String) {
        self.contents = contents
        updateSpinnerState()
        refreshControl?.endRefreshing()
        tableView.reloadData()
        emptyFolderLabel?.isHidden = !contents.isFolderEmpty
    }

    func folderContentsProvider(provider: FolderContentsProviding, didFailWithErrorMessage message: String) {
        updateSpinnerState()
        refreshControl?.endRefreshing()
        DispatchQueue.main.asyncAfter(seconds: 0.4) { [unowned self] in
             self.presentAlertWithMessage(message, title: StringHolder.errorAlertTitle)
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionsMap.sectionForIndex(section)

        switch section {
        case .folders: return contents?.folders?.count ?? 0
        case .files: return contents?.files?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let contents = contents else {
            return 0
        }
        let section = SectionsMap.sectionForIndex(section)
        switch (section) {
        case .folders where !contents.noFolders:
            return itemHeaderHeight
        case .files where !contents.noFiles:
            return itemHeaderHeight
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionsMap.sectionForIndex(section)
        guard
            let header = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?.first as? SectionHeaderView,
            let contents = contents
            else { return nil }

        var labelText = String()
        switch (section) {
        case .folders where !contents.noFolders:
            labelText = StringHolder.folders
        case .files where !contents.noFiles:
            labelText = StringHolder.files
        default:
            return nil
        }
        header.headerLabel.text = labelText
        header.headerLabel.textColor = UIColor.driveBlackColor()
        header.backgroundColor = UIColor.driveBackgroundColor()
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionsMap.sectionForIndex(indexPath.section)

        switch section {
        case .folders: return folderCellForIndexPath(indexPath)
        case .files: return fileCellForIndexPath(indexPath)
        }
    }

    func folderCellForIndexPath(_ indexPath: IndexPath) -> DriveItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! DriveItemCell
        if let folders = contents?.folders {
            let folder = folders[indexPath.row]
            let position = CellPositionType.cellPositionTypeForIndex(indexPath.row, in: folders)
            cell.configure(with: folder, cellPosition: position)
        }
        return cell
    }

    func fileCellForIndexPath(_ indexPath: IndexPath) -> DriveItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! DriveItemCell
        if let files = contents?.files {
            let file = files[indexPath.row]
            let position = CellPositionType.cellPositionTypeForIndex(indexPath.row, in: files)
            let enableCheckbox = configuration.mode == .selectFile
            cell.configure(with: file, cellPosition: position, enableCheckbox: enableCheckbox)
            cell.isChecked = file === selectedItem?.file
        }
        return cell
    }

     // MARK: - Table view data delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SectionsMap.sectionForIndex(indexPath.section)
        switch section {
        case .folders:
            openFolder(folderCellAt: indexPath)
        case .files:
            if configuration.isFileSelectionEnabled {
                updateCheckboxState(fileCellAt: indexPath)
            }
        }
    }

    private func openFolder(folderCellAt indexPath:IndexPath) {
        guard let folder = contents?.folders?[indexPath.row] else {
            return
        }
        let provider = DriveFolderContentsProvider()
        let browser = DriveBrowser(folder:folder, configuration:configuration, provider:provider, completionHandler:completionHandler)
        navigationController?.pushViewController(browser, animated: true)
    }

    private func updateCheckboxState(fileCellAt indexPath:IndexPath) {

        guard
            let cell = tableView.cellForRow(at: indexPath) as? DriveItemCell,
            let contents = contents,
            let files = contents.files else {
            return
        }

        selectedItem = cell.isChecked ? nil : (file: files[indexPath.row], index: indexPath.row)
        cell.toggle()
        tableView.reloadData()
        let toolbar = navigationController?.toolbar as? ShareToolbar
        toolbar?.updateTitle()

        if let selectFileConfiguration = configuration as? SelectFileConfiguration {
            selectFileConfiguration.selectedItem = selectedItem
        }
    }

    private func isCellChecked(at indexPath:IndexPath) -> Bool {
        if let currentFolderId = contents?.currentFolder.identifier,
            let selectedItem = selectedItem,
            let parents = selectedItem.file.parents, parents.contains(currentFolderId) {
            return indexPath.row == selectedItem.index
        }
        return false
    }

    private func allFilesIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        guard let files = contents?.files else {
            return []
        }
        for (row, _) in files.enumerated() {
            indexPaths.append(IndexPath(row:row, section: SectionsMap.files.rawValue))
        }
        return indexPaths
    }

    internal func saveFile(_ file: APIFile, toDriveFolder folder: GTLRDrive_File) {
        let transferManager = FileTransferManager.shared
        transferManager.delegate = self
        let transfer = API2DriveTransfer(file: file, destinationFolder: folder)
        transferManager.execute(transfer: transfer)
        addTransferView(toParent: tableView, trackTransfer: transfer)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // MARK: - FileTransferManagerDelegate

    func transfer(_ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            if let view = self?.navigationController?.view,
                let file = file as? APIFile {
                self?.refresh()
                ToastView.showInParent(view, withText: StringHolder.fileHasBeenSavedOnGoogleDriveMessage(fileName: file.fileName), forDuration: 2.0) { [weak self] in
                    self?.dismissBrowser(completion: nil)
                }

            }
        }
    }

    func transfer(_ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()

            self?.presentAlertWithMessage(errorMessage, title: StringHolder.fileSave, okAction: { [weak self] in
                    self?.dismissBrowser(completion: nil)
            })
        }
    }

    func transfer(_ transfer: Transferable?, didCancelExecuting operation: Operation?) {
        DispatchQueue.main.async { [weak self] in
            self?.closeTransferView()
            if let view = self?.navigationController?.view {
                ToastView.showInParent(view, withText: StringHolder.fileSaveHasBeenCancelled, forDuration: 2.0) { [weak self] in
                    self?.dismissBrowser(completion: nil)
                }
            }
        }
    }

    func transfer(_ transfer: Transferable?, didProceedWithProgress progress: Float, bytesProceededPerOperation bytesProceeded: String, totalSize: String) {
        DispatchQueue.main.async { [weak self] in
            self?.transferView?.update(progress: progress)
        }
    }

    // MARK: - StudentsSelectionTableViewControllerDelegate

    func studentsSelectionTableViewController(_ controller: StudentsSelectionTableViewController?, didFinishWith shareOptions: ShareOptions) {
        dismissBrowser { [weak self] in
            if let selectedItem = self?.selectedItem {
                self?.completionHandler?(selectedItem.file, shareOptions)
            }
        }
    }

    func studentsSelectionTableViewControllerDidCancel() {
        // do nothing
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustFloatingTransferView(scrollView)
    }

}
