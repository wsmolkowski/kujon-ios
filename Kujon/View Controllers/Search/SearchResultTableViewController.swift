//
//  SearchResultTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchResultTableViewController: RefreshingTableViewController, SearchProviderDelegate {


    var array: Array<SearchElementProtocol> = Array()
    var searchQuery: String! = nil
    var provider: SearchProviderProtocol! = nil
    let myCellId = "SearchResultsCell"
    var number = 0;
    var isThereNext = true

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SearchResultTableViewController.back), andTitle: StringHolder.searchResults)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SearchResultsCell", bundle: nil), forCellReuseIdentifier: myCellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        if (provider != nil && searchQuery != nil) {
            provider.setDelegate(self)

        }
    }

    override func loadData() {
        if (isThereNext) {
            isQuering = true
            isThereNext = false
            provider.search(searchQuery, more: number)
            number = number + 20
        }
    }

    func isThereNextPage(_ isThere: Bool) {
        self.isThereNext = isThere
    }

    func onErrorOccurs(_ text: String) {
        showAlertApi("Bład",text:text,succes: {
            self.isQuering = false
            self.isThereNext = true
            self.number = self.number - 20;
            self.loadData()
        },cancel: {
            self.back()
        })
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }

    func searchedItems(_ array: Array<SearchElementProtocol>) {
        self.refreshControl?.endRefreshing()
        isQuering = false
        self.array = self.array + array
        self.tableView.reloadData();
        if array.isEmpty {
            EmptyStateView.showNoResultsAlert(inParent: view)
        }
    }



    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchResultsCell
        cell.title = array[indexPath.row].getTitle()
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].reactOnClick(self.navigationController!)
    }
    var isQuering = false

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contetyYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contetyYOffset
        if (distanceFromBottom <= height) {
            NSlogManager.showLog("End of list, load more")
            if (!isQuering) {
                loadData()
            }
        }
    }

}
