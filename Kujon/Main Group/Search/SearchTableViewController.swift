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
                                             CourseSearchElement(),
                                             FacultySearchElement(),
                                             ProgrammeSearchElement(),
                                             ThesisSearchElement() ]

    weak var delegate: NavigationMenuProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(SearchTableViewController.openDrawer), andTitle: StringHolder.search)
        super.didReceiveMemoryWarning()
        array.forEach { $0.registerView(self.tableView) }
        tableView.separatorStyle = .None
    }

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = array[indexPath.row].provideUITableViewCell(tableView, cellForRowAtIndexPath: indexPath)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SearchTableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }

    // MARK: SearchTableViewCellDelegate

    func searchTableViewCell(cell: SearchTableViewCell, didTriggerSearchWithQuery searchQuery: String) {
        let controller = SearchResultTableViewController(nibName: "SearchResultTableViewController", bundle: nil)
        controller.provider = array[cell.index].provideSearchProtocol()
        controller.searchQuery = searchQuery.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func searchTableViewCellDidChangeSelection() {
        tableView.visibleCells.forEach { ($0 as! SearchTableViewCell).reset() }
    }

}
