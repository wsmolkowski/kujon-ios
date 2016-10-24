//
//  SearchTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,NavigationDelegate, SearchTableViewCellDelegate {

    let array: Array<SearchViewProtocol> = [ UserSearchElement(),
                                             FacultySearchElement(),
                                             CourseSearchElement(),
                                             ProgrammeSearchElement(),
                                             ThesisSearchElement() ]

    weak var delegate: NavigationMenuProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(SearchTableViewController.openDrawer), andTitle: StringHolder.search)
        super.didReceiveMemoryWarning()
        array.forEach { $0.registerView(self.tableView) }
        tableView.separatorStyle = .none
    }

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
        tableView.visibleCells.forEach { ($0 as! SearchTableViewCell).textField.resignFirstResponder() }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = array[indexPath.row].provideUITableViewCell(tableView, cellForRowAtIndexPath: indexPath)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }

    // MARK: SearchTableViewCellDelegate

    func searchTableViewCell(_ cell: SearchTableViewCell, didTriggerSearchWithQuery searchQuery: String) {
        let controller = SearchResultTableViewController(nibName: "SearchResultTableViewController", bundle: nil)
        controller.provider = array[cell.index].provideSearchProtocol()
        controller.searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func searchTableViewCellDidChangeSelection() {
        tableView.visibleCells.forEach { ($0 as! SearchTableViewCell).reset() }
    }

}
