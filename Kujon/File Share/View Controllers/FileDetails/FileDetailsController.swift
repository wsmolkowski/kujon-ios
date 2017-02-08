//
//  FileDetailsController.swift
//  Kujon
//
//  Created by Adam on 07.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

protocol FileDetailsControllerDelegate: class {

    func fileDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?)

    func fileDetailsController(_ controller: FileDetailsController?, didUpdateFile file: APIFile, with shareOptions: ShareOptions, loadedForCache courseStudents: [SimpleUser]?)
}

class FileDetailsController: UITableViewController, CourseDetailsProviderDelegate, AllStudentsSwitchCellDelegate {

    private enum SectionMap: Int {
        case header = 0
        case students

        static func sectionForIndex(_ index:Int) -> SectionMap {
            if let section = SectionMap(rawValue: index) {
                return section
            }
            fatalError("Invalid section index")
        }
    }

    private let sectionsCount: Int = 2
    private let itemCellId: String = "itemCellId"
    private let headerCellHeight: CGFloat = 45.0
    private let fileDetailsCellId = "FileDetailsCellId"
    private let allStudentsSwitchCellId = "AllStudentsSwitchCellId"
    private let separatorCellId = "SeparatorCellId"


    internal weak var delegate: FileDetailsControllerDelegate?
    private var spinner = SpinnerView()
    private var rightBarButtonItem: UIBarButtonItem?
    private let file: APIFile
    private lazy var shareFileProvider = APIShareFileProvider()
    private var courseDetailsProvider: CourseDetailsProvider?
    private var students: [SimpleUser] = []
    private var selectedStudents: Set<SimpleUser> = Set() {
        didSet {
            rightBarButtonItem?.isEnabled = didUserChangeShareOptions()
        }
    }
    private var areAllStudentsSelected: Bool {
        return selectedStudents.count == students.count
    }
    private var allStudentsEnabled: Bool = false
    private var selectedStudentsAtLoad: Set<SimpleUser> = Set()
    private var temporarySelection: Set<SimpleUser>?


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Initial section

    init(file: APIFile, courseId: String, termId: String, courseStudents: [SimpleUser]?) {
        self.file = file
        super.init(style: .plain)
        if let courseStudents = courseStudents, !courseStudents.isEmpty {
            students = courseStudents
            let userIds = sharedIdsForFile(file: file)
            setSelectedStudents(forIds: userIds)
            selectedStudentsAtLoad = selectedStudents
            allStudentsEnabled = areAllStudentsSelected
            updateControllerOnAllStudentsSwichChange()
            return
        }
        courseDetailsProvider = CourseDetailsProvider()
        courseDetailsProvider?.delegate = self
        courseDetailsProvider?.loadCourseDetails(courseId, andTermId: termId)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        title = StringHolder.fileDetailsTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSpinner()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "CheckboxCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        tableView.register(UINib(nibName: "FileDetailsCell", bundle: nil), forCellReuseIdentifier: fileDetailsCellId)
        tableView.register(UINib(nibName: "SeparatorCell", bundle: nil), forCellReuseIdentifier: separatorCellId)
        tableView.register(UINib(nibName: "AllStudentsSwitchCell", bundle: nil), forCellReuseIdentifier: allStudentsSwitchCellId)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
        tableView.tintColor = UIColor.kujonBlueColor()
        tableView.reloadData()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.kujonBlueColor()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: StringHolder.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShareDetailsController.cancelButtonDidTap))

        rightBarButtonItem = UIBarButtonItem(title: StringHolder.change, style: UIBarButtonItemStyle.done, target: self, action: #selector(FileDetailsController.saveButtonDidTap))
        rightBarButtonItem?.isEnabled = didUserChangeShareOptions()

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func addSpinner() {
        let spinnerSize: CGFloat = 50.0
        let correction: CGFloat = spinnerSize / 2.0
        spinner.frame.origin = CGPoint(x: view.bounds.midX - correction, y: view.bounds.midY - correction)
        spinner.frame.size = CGSize(width: spinnerSize, height: spinnerSize)
        spinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        navigationController?.view.addSubview(spinner)
        spinner.isHidden = courseDetailsProvider == nil
    }

    private func sharedIdsForFile(file: APIFile) -> [String] {
        guard
            let sharedWith = file.shareOptions.sharedWith,
            let sharedWithIds = file.shareOptions.sharedWithIds else {
            return []
        }
        switch sharedWith {
        case .all:
            return students.map { $0.userId }
        case .list:
            return sharedWithIds
        case .none:
            return []
        }
    }

    private func setSelectedStudents(forIds ids: [String]) {
        var selectedGroup: Set<SimpleUser> = Set()
        for student in students {
            if ids.contains(student.userId) {
                selectedGroup.insert(student)
            }
        }
        selectedStudents = selectedGroup
    }

    private func didUserChangeShareOptions() -> Bool {
        let difference = selectedStudents.symmetricDifference(selectedStudentsAtLoad)
        return !difference.isEmpty
    }

    internal func cancelButtonDidTap() {
        dismiss(animated: true, completion: { [weak self] in
            self?.delegate?.fileDetailsControllerDidCancel(loadedForCache: self?.students)
        })
    }

    internal func saveButtonDidTap() {
        guard let fileId = file.fileId else {
            return
        }
        let finalStudentsList = [SimpleUser](selectedStudents)
        let studentsIds = mapToNonNilIds(inUsers: finalStudentsList)
        let didSelectAllStudents = selectedStudents.count == students.count

        let shareOptions: ShareOptions = didSelectAllStudents ? ShareOptions(sharedWith: .all) : ShareOptions(sharedWith: .list, ids: studentsIds)
        spinner.isHidden = false
        shareFileProvider.shareFile(fileId, shareOptions: shareOptions, successHandler: { [weak self] (file) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.spinner.isHidden = true
            }
            strongSelf.delegate?.fileDetailsController(strongSelf, didUpdateFile: strongSelf.file, with: shareOptions, loadedForCache: strongSelf.students)
            strongSelf.dismiss(animated: true, completion: nil)
            }, failureHandler: { [weak self] (message) in
                DispatchQueue.main.async { [weak self] in
                    self?.spinner.isHidden = true
                    self?.presentAlertWithMessage(message, title: StringHolder.errorAlertTitle)
                }
        })
    }

    private func mapToNonNilIds(inUsers users: [SimpleUser]) -> [String] {
        var ids: [String] = []
        for user in users {
            if let id = user.id { ids.append(id) }
        }
        return ids
    }

    // MARK: - CourseDetailsProviderDelegate

    func onCourseDetailsLoaded(_ courseDetails: CourseDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.isHidden = true
            guard
                let strongSelf = self,
                let participants = courseDetails.participants else {
                return
            }
            strongSelf.students = participants
            let userIds = strongSelf.sharedIdsForFile(file: strongSelf.file)
            strongSelf.setSelectedStudents(forIds: userIds)
            strongSelf.selectedStudentsAtLoad = strongSelf.selectedStudents
            strongSelf.rightBarButtonItem?.isEnabled = false
            strongSelf.allStudentsEnabled = strongSelf.areAllStudentsSelected
            strongSelf.updateControllerOnAllStudentsSwichChange()
            strongSelf.tableView.reloadData()
        }
    }

    func onErrorOccurs(_ text: String) {
        spinner.isHidden = true
        presentAlertWithMessage(text, title: StringHolder.errorAlertTitle, showCancelButton: false) { [weak self] in
            self?.delegate?.fileDetailsControllerDidCancel(loadedForCache: self?.students)
        }
    }

    func onUsosDown() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.isHidden = true
            self?.refreshControl?.endRefreshing()
            guard let strongSelf = self else {
                return
            }
            EmptyStateView.showUsosDownAlert(inParent: strongSelf.view)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)
        switch section {
        case .header: return 3
        case .students: return students.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)

        switch section {
        case .header: return headerCellFor(indexPath)
        case .students: return itemCellForIndexPath(indexPath)
        }
    }

    func itemCellForIndexPath(_ indexPath: IndexPath) -> CheckboxCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! CheckboxCell
        let student = students[indexPath.row]
        let isChecked = selectedStudents.contains(student)
        cell.configure(with: student.fullName(), cellPosition: .universal, isChecked:isChecked)
        return cell
    }

    func headerCellFor(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return fileDetailsCellForIndexPath(indexPath)
        case 1: return separatorCellForIndexPath(indexPath)
        case 2: return switchCellForIndexPath(indexPath)
        default: fatalError("Index out of range")
        }
    }

    func fileDetailsCellForIndexPath(_ indexPath: IndexPath) -> FileDetailsCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fileDetailsCellId, for: indexPath) as! FileDetailsCell
        cell.configure(with:file)
        return cell
    }

    func separatorCellForIndexPath(_ indexPath: IndexPath) -> SeparatorCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: separatorCellId, for: indexPath) as! SeparatorCell
        cell.optionalTitleLabel.text = "Kto ma dostęp"
        return cell
    }

    func switchCellForIndexPath(_ indexPath: IndexPath) -> AllStudentsSwitchCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: allStudentsSwitchCellId, for: indexPath) as! AllStudentsSwitchCell
        cell.delegate = self
        cell.setSwitchOn(allStudentsEnabled)
        return cell
    }

    // MARK: - Table view data delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCheckboxState(at: indexPath)
    }

    private func updateCheckboxState(at indexPath:IndexPath) {
        let section = SectionMap.sectionForIndex(indexPath.section)
        guard section == .students else {
            return
        }

        let studentForCurrentCell = students[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! CheckboxCell

        if selectedStudents.contains(studentForCurrentCell) {
            selectedStudents.remove(studentForCurrentCell)
        } else {
            selectedStudents.insert(studentForCurrentCell)
        }
        cell.toggle()
        allStudentsEnabled = areAllStudentsSelected
        tableView.reloadData()
    }

    // MARK: - AllStudentsSwitchCellDelegate

    func allStudentsSwitchCell(_ cell: AllStudentsSwitchCell?, didChangeSwitchState isOn: Bool) {
        allStudentsEnabled = isOn
        updateControllerOnAllStudentsSwichChange()
    }

    private func updateControllerOnAllStudentsSwichChange() {
        switch allStudentsEnabled {
        case true:
            temporarySelection = areAllStudentsSelected ? Set<SimpleUser>() : selectedStudents
            if let allStudentsIds = students.map({ $0.userId }) as? [String] {
                setSelectedStudents(forIds: allStudentsIds)
            }
        case false:
            if let temporarySelection = temporarySelection {
                selectedStudents = temporarySelection
                self.temporarySelection = nil
                if let tempStudentsIds = temporarySelection.map({ $0.userId }) as? [String] {
                    setSelectedStudents(forIds: tempStudentsIds)
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }

    }


}
