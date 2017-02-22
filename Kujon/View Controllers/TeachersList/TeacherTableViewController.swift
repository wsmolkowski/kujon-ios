//
//  TeacherTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 13/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherTableViewController: RefreshingTableViewController, NavigationDelegate, LecturerProviderDelegate, UISearchResultsUpdating {

    private let TeachCellId = "teacherCellId"
    weak var delegate: NavigationMenuProtocol! = nil
    let lecturerProvider = ProvidersProviderImpl.sharedInstance.provideLecturerProvider()
    private var allLecturers: Array<SimpleUser>! = []
    private var filteredLecturers: [SimpleUser] = []
    private let searchController = UISearchController(searchResultsController: nil)


    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(TeacherTableViewController.openDrawer),andTitle: StringHolder.lecturers)
        self.tableView.register(UINib(nibName: "AccessoryItemCell", bundle: nil), forCellReuseIdentifier: TeachCellId)
        lecturerProvider.delegate = self
        addToProvidersList(provider: lecturerProvider)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        lecturerProvider.loadLecturers()
    }

    func onLecturersLoaded(_ lecturers: Array<SimpleUser>) {
        self.allLecturers = lecturers
        self.filteredLecturers = lecturers
        if !lecturers.isEmpty {
            addSearchController()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.lecturerProvider.reload()
            self.lecturerProvider.loadLecturers()
            }, cancel: {})
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    func openDrawer() {
        if searchController.isActive {
            searchController.searchBar.resignFirstResponder()
        }
        delegate?.toggleLeftPanel()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredLecturers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeachCellId, for: indexPath) as! AccessoryItemCell
        let myUser: SimpleUser = self.filteredLecturers[indexPath.row]
        cell.titleLabel.text = myUser.lastName + " " + myUser.firstName
        cell.setStyle(.arrowRight)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.connected(indexPath)
    }


    func connected(_ indexPath: IndexPath) {
        guard indexPath.row < filteredLecturers.count else {
            return
        }
        let myUser: SimpleUser = self.filteredLecturers[indexPath.row]
        let currentTeacher  = CurrentTeacherHolder.sharedInstance
        currentTeacher.currentTeacher = myUser
        let controller = TeacherDetailTableViewController()
        controller.simpleUser = myUser
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    // MARK - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        let filterKey: String = searchController.searchBar.text!
        filteredLecturers = allLecturers.filterWithKey(filterKey) as! [SimpleUser]
        tableView.reloadData()
    }


}
