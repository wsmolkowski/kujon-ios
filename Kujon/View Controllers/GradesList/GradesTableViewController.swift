//
//  GradesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 24/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class GradesTableViewController: RefreshingTableViewController, NavigationDelegate, GradesProviderDelegate, TermsProviderDelegate, UISearchResultsUpdating {

    weak var delegate: NavigationMenuProtocol! = nil
    let gradesProvider = ProvidersProviderImpl.sharedInstance.provideGradesProvider()
    private let GradeCellIdentiefer = "GradeCellId"
    let textId = "myTextSuperId"
    private var allTermGrades  = SortedDictionary<PreparedGrades>()
    private var filteredTermGrades = SortedDictionary<PreparedGrades>()
    private var didLoadData = false;
    private let kSectionHeight: CGFloat = 40.0
    private let termsProvider = ProvidersProviderImpl.sharedInstance.provideTermsProvider()
    private var selectedTermId: String?
    private let searchController = UISearchController(searchResultsController: nil)


    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(GradesTableViewController.openDrawer),andTitle: StringHolder.grades)
        gradesProvider.delegate = self
        self.tableView.register(UINib(nibName: "Grade2TableViewCell", bundle: nil), forCellReuseIdentifier: GradeCellIdentiefer)
        termsProvider.delegate = self
        addToProvidersList(provider: termsProvider)
        addToProvidersList(provider: gradesProvider)
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        didLoadData = false;
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
        gradesProvider.loadGrades()
    }

    func openDrawer() {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
        delegate?.toggleLeftPanel()
    }

    func onGradesLoaded(preparedTermGrades: Array<PreparedTermGrades>) {
        didLoadData = true
        self.allTermGrades = SortedDictionary<PreparedGrades>(preparedTermGrades: preparedTermGrades)
        self.filteredTermGrades = allTermGrades
        if !preparedTermGrades.isEmpty {
            addSearchController()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.gradesProvider.reload()
            self.gradesProvider.loadGrades()
        }, cancel: {
            self.refreshControl?.endRefreshing()
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return noDataCondition() ? 1 : filteredTermGrades.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(noDataCondition()){
            return 0
        }
        return filteredTermGrades.itemsCountInSection(index: section)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(noDataCondition()){
            return 0
        }
        return kSectionHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(noDataCondition()) {
            return nil
        }
        let termId = filteredTermGrades.sections[section]
        let gradeDescriptive = filteredTermGrades.descriptions[section]
        let headerTitle: String = String(format: "%@,  średnia ocena: %@", termId, gradeDescriptive)
        let header = createLabelForSectionTitle(headerTitle, middle: true, height: kSectionHeight)
        let tapRecognizer = IdentifiedTapGestureRecognizer(target: self, action: #selector(CoursesTableViewController.headerDidTap(with:)))
        tapRecognizer.id = section
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        header.addGestureRecognizer(tapRecognizer)
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(noDataCondition()){
            let cell = UITableViewCell(style: .default, reuseIdentifier: textId)
            cell.textLabel?.font = UIFont.kjnTextStyle2Font()
            if(didLoadData){
                cell.textLabel?.text = StringHolder.no_grades
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: GradeCellIdentiefer, for: indexPath) as! Grade2TableViewCell
        let preparedGrade = filteredTermGrades.itemForIndexPath(indexPath)
        cell.grade = preparedGrade.grades
        cell.courseName = preparedGrade.courseName
        return cell
    }

    private func noDataCondition()->Bool{
        return filteredTermGrades.sections.count == 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  !noDataCondition() {
            let preparedGrade = filteredTermGrades.itemForIndexPath(indexPath)
            let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
            courseDetails.courseId = preparedGrade.courseId
            courseDetails.termId = preparedGrade.termId
            self.navigationController?.pushViewController(courseDetails, animated: true)
        }

    }

    // MARK: Term Detail Popup

    func headerDidTap(with tapGestureRecognizer: IdentifiedTapGestureRecognizer) {
        let section = tapGestureRecognizer.id
        selectedTermId = filteredTermGrades.sections[section]
        termsProvider.loadTerms()
    }

    private func presentPopUpWithTerm(_ term:Term) {
        let termPopUp = TermsPopUpViewController(nibName: "TermsPopUpViewController", bundle: nil)
        termPopUp.modalPresentationStyle = .overCurrentContext
        parent?.present(termPopUp, animated: false) { [weak termPopUp] in
            termPopUp?.showAnimate();
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

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    // MARK - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let filterKey: String = searchController.searchBar.text!
        filteredTermGrades = allTermGrades.copyFilteredWithKey(filterKey)
        tableView.reloadData()
    }


}
