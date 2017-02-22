//
//  CoursesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CoursesTableViewController: RefreshingTableViewController, NavigationDelegate,CourseProviderDelegate, TermsProviderDelegate, UISearchResultsUpdating {

    private let CourseCellId = "ActiveCourseCell"
    private let courseProvider = ProvidersProviderImpl.sharedInstance.provideCourseProvider()
    private let termsProvider = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    private var allSections: SortedDictionary<Course> = SortedDictionary(coursesWrappers: [])
    private var filteredSections: SortedDictionary<Course> = SortedDictionary(coursesWrappers: [])
    weak var delegate: NavigationMenuProtocol! = nil
    private var selectedTermId: String?
    private let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CoursesTableViewController.openDrawer),andTitle: StringHolder.courses)
        self.tableView.register(UINib(nibName: "ActiveCourseCell", bundle: nil), forCellReuseIdentifier: CourseCellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        self.tableView.separatorStyle = .none
        courseProvider.delegate = self
        addToProvidersList(provider:courseProvider)
        termsProvider.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        if searchController.isActive {
            searchController.isActive = false
        }
        super.viewWillDisappear(animated)
    }

    private func addSearchController() {
        searchController.searchBar.barTintColor = UIColor.greyBackgroundColor()
        searchController.searchBar.tintColor = UIColor.kujonBlueColor()
        searchController.searchBar.placeholder = "Szukaj"

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func loadData() {
        courseProvider.provideCourses()
    }

    func coursesProvided(_ courses: Array<CoursesWrapper>) {

        self.allSections = SortedDictionary(coursesWrappers: courses)
        self.filteredSections = allSections
        if !courses.isEmpty {
            addSearchController()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            [unowned self] in
            self.courseProvider.provideCourses()
        }, cancel: { [unowned self] in
            self.refreshControl?.endRefreshing()
        })
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }


    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
        delegate?.toggleLeftPanel()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSections.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSections.itemsCountInSection(index: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = filteredSections.itemForIndexPath(indexPath)
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.course = course
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCellId, for: indexPath) as! ActiveCourseCell
        let course = filteredSections.itemForIndexPath(indexPath)
        cell.configure(courseName: course.courseName, filesNumber: course.filesCount, showFolderIcon: false)
        return cell
    }



    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = createLabelForSectionTitle(filteredSections.sections[section], middle: true)
        let tapRecognizer = IdentifiedTapGestureRecognizer(target: self, action: #selector(CoursesTableViewController.headerDidTap(with:)))
        tapRecognizer.id = section
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        header.addGestureRecognizer(tapRecognizer)
        return header
    }

    // MARK: Term Detail Popup

    func headerDidTap(with tapGestureRecognizer: IdentifiedTapGestureRecognizer) {
        let sectionIndex = tapGestureRecognizer.id
        let sectionCourses = filteredSections.itemsInSection(index: sectionIndex)
        selectedTermId = sectionCourses[0].termId
        termsProvider.loadTerms()

    }

    private func presentPopUpWithTerm(_ term:Term) {
        let termPopUp = TermsPopUpViewController(nibName: "TermsPopUpViewController", bundle: nil)
        termPopUp.modalPresentationStyle = .overCurrentContext
        parent?.present(termPopUp, animated: false) { [unowned termPopUp] in
            termPopUp.showAnimate();
        }
        termPopUp.showInView(term)
    }

    // MARK: TermsProviderDelegate

    func onTermsLoaded(_ terms: Array<Term>) {
        guard let termId = selectedTermId else {
            return
        }
        for term in terms {
            if term.termId == termId {
                presentPopUpWithTerm(term)
                break
            }
        }
        selectedTermId = nil
    }

    // MARK - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let filterKey: String = searchController.searchBar.text!
        filteredSections = allSections.copyFilteredWithKey(filterKey)
        tableView.reloadData()
    }

}

