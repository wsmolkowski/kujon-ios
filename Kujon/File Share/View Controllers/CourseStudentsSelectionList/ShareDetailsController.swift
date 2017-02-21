//
//  ShareDetailsController
//  Kujon
//
//  Created by Adam on 20.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

protocol ShareDetailsControllerDelegate: class {

    func shareDetailsControllerDidCancel(loadedForCache courseStudents: [SimpleUser]?)

    func shareDetailsController(_ controller: ShareDetailsController?, didFinishWith shareOptions: ShareOptions, loadedForCache courseStudents: [SimpleUser]?)
}

class ShareDetailsController: UITableViewController, CourseDetailsProviderDelegate, UISearchResultsUpdating {

    internal weak var delegate: ShareDetailsControllerDelegate?
    private var spinner = SpinnerView()
    private var rightBarButtonItem: UIBarButtonItem?
    private let itemCellId: String = "itemCellId"
    private let headerCellHeight: CGFloat = 45.0
    let searchController = UISearchController(searchResultsController: nil)

    private var courseDetailsProvider: CourseDetailsProvider?
    private var studentsArray: [SimpleUser] = []
    private var students = SortedDictionary<SimpleUser>(with: [])
    private var selectedStudents: Set<SimpleUser> = Set() {
        didSet {
            rightBarButtonItem?.isEnabled = !selectedStudents.isEmpty
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Initial section

    init(courseId: String, termId: String, courseStudentsCached: [SimpleUser]?) {
        super.init(style: .plain)
        if let courseStudentsCached = courseStudentsCached, !courseStudentsCached.isEmpty {
            studentsArray = courseStudentsCached
            students = SortedDictionary<SimpleUser>(with: studentsArray)
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
        setSearchBarAppearance()
        configureTableView()
        configureNavigationBar()
        title = StringHolder.sutdentsListTitle
        if !studentsArray.isEmpty {
            addSearchController()
            tableView.reloadData()
        }

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

    func setSearchBarAppearance() {
        let barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self])
        let attr: [String: Any] = [ NSFontAttributeName : UIFont.kjnFontLatoRegular(size: 16)!,
                                    NSForegroundColorAttributeName : UIColor.kujonBlueColor() ]
        barButtonAppearanceInSearchBar.setTitleTextAttributes(attr, for: .normal)
        barButtonAppearanceInSearchBar.title = StringHolder.cancel
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "CheckboxCell", bundle: nil), forCellReuseIdentifier: itemCellId)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.driveBackgroundColor()
        tableView.tintColor = UIColor.kujonBlueColor()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.tintColor = UIColor.kujonBlueColor()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: StringHolder.cancel, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShareDetailsController.cancelButtonDidTap))

        rightBarButtonItem = UIBarButtonItem(title: StringHolder.share, style: UIBarButtonItemStyle.done, target: self, action: #selector(ShareDetailsController.shareButtonDidTap))
        rightBarButtonItem?.isEnabled = false

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func addSearchController() {
        searchController.searchBar.barTintColor = UIColor.greyBackgroundColor()
        searchController.searchBar.tintColor = UIColor.kujonBlueColor()
        searchController.searchBar.placeholder = StringHolder.search

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    private func addSpinner() {
        let spinnerSize: CGFloat = 50.0
        let correction: CGFloat = spinnerSize / 2.0
        spinner.frame.origin = CGPoint(x: view.bounds.midX - correction, y: view.bounds.midY - correction)
        spinner.frame.size = CGSize(width: spinnerSize, height: spinnerSize)
        spinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        spinner.isHidden = !(courseDetailsProvider?.isFetching ?? false)
        navigationController?.view.addSubview(spinner)
    }

    internal func cancelButtonDidTap() {

        if searchController.isActive {
            searchController.dismiss(animated: true, completion: { [weak self] in
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.delegate?.shareDetailsControllerDidCancel(loadedForCache: self?.studentsArray)
                })
            })
        } else {
            dismiss(animated: true, completion: { [weak self] in
                self?.delegate?.shareDetailsControllerDidCancel(loadedForCache: self?.studentsArray)
            })
        }
    }

    internal func shareButtonDidTap() {

        if searchController.isActive {
            searchController.dismiss(animated: true, completion: { [weak self] in
                self?.dismiss(animated: true, completion: { [weak self] in
                    let selectedStudentsSet = self?.selectedStudents ?? Set<SimpleUser>()
                    let studentsArray = [SimpleUser](selectedStudentsSet)
                    let studentsIds = self?.mapToNonNilIds(inUsers: studentsArray) ?? []
                    let shareOptions = ShareOptions(sharedWith: .list, ids: studentsIds)
                    self?.delegate?.shareDetailsController(self, didFinishWith: shareOptions, loadedForCache: self?.studentsArray)
                })

            })
        } else {
            dismiss(animated: true, completion: { [weak self] in
                let selectedStudentsSet = self?.selectedStudents ?? Set<SimpleUser>()
                let studentsArray = [SimpleUser](selectedStudentsSet)
                let studentsIds = self?.mapToNonNilIds(inUsers: studentsArray) ?? []
                let shareOptions = ShareOptions(sharedWith: .list, ids: studentsIds)
                self?.delegate?.shareDetailsController(self, didFinishWith: shareOptions, loadedForCache: self?.studentsArray)
            })

        }
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
            guard let participants = courseDetails.participants else {
                return
            }
            self?.studentsArray = participants
            self?.students = SortedDictionary<SimpleUser>(with: participants)
            self?.addSearchController()
            self?.tableView.reloadData()
        }
    }

    func onErrorOccurs(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.isHidden = true
            self?.presentAlertWithMessage(text, title: StringHolder.errorAlertTitle, showCancelButton: false) { [weak self] in
                self?.delegate?.shareDetailsControllerDidCancel(loadedForCache: self?.studentsArray)
            }
        }
    }

    func onUsosDown() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.isHidden = true
            guard let strongSelf = self else {
                return
            }
            self?.tableView.visibleCells.forEach { $0.isHidden = true }
            EmptyStateView.showUsosDownAlert(inParent: strongSelf.view)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return students.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.itemsCountInSection(index: section)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return students.sections
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! CheckboxCell
        let sectionItems = students.itemsInSection(index: indexPath.section)
        let itemIndex = indexPath.row
        let student = sectionItems[itemIndex]
        let position = CellPositionType.cellPositionTypeForIndex(itemIndex, in: sectionItems as [AnyObject])
        let isChecked = selectedStudents.contains(student)
        cell.configure(with: student.fullName(), cellPosition: position, isChecked:isChecked)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)?.first as? SectionHeader
            else { return nil }
        let sectionName = students.sections[section]
        header.titleLabel.text = sectionName
        header.titleLabel.textColor = UIColor.driveBlackColor()
        header.backgroundColor = UIColor.driveBackgroundColor()
        header.separatorTopEnabled = false
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerCellHeight
    }

    // MARK: - Table view data delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCheckboxState(at: indexPath)
    }

    private func updateCheckboxState(at indexPath:IndexPath) {
        let studentForCurrentCell = students.itemForIndexPath(indexPath)
        let cell = tableView.cellForRow(at: indexPath) as! CheckboxCell

        if selectedStudents.contains(studentForCurrentCell) {
            selectedStudents.remove(studentForCurrentCell)
        } else {
            selectedStudents.insert(studentForCurrentCell)
        }
        cell.toggle()
        tableView.reloadData()
    }

    // MARK - UISearchResultsUpdating


    func updateSearchResults(for searchController: UISearchController) {
        filterStudentsWithKey(searchController.searchBar.text!)
    }

    private func filterStudentsWithKey(_ filterKey: String) {
        students = SortedDictionary<SimpleUser>(with: studentsArray, filterKey: filterKey)
        tableView.reloadData()
    }

    private func allFilesIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        for (sectionIndex, sectionName) in students.sections.enumerated() {
            let sectionItems = students.itemsInSection(name: sectionName)
            for (itemIndex, _) in sectionItems.enumerated() {
                indexPaths.append(IndexPath(row:itemIndex, section: sectionIndex))
            }
        }
        return indexPaths
    }

}
