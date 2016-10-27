//
//  SearchResultTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController, SearchProviderDelegate {


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
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(SearchResultTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        askForData()
    }

    override func viewDidAppear(_ animated: Bool) {
        refreshControl?.beginRefreshingManually()
    }


    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        self.array = Array()
        self.tableView.reloadData();
        number = 0
        askForData()
    }

    func isThereNextPage(_ isThere: Bool) {
        self.isThereNext = isThere
    }

    func onErrorOccurs(_ text: String) {
        showAlertApi("Bład",text:text,succes: {
            self.isQuering = false
            self.isThereNext = true
            self.number = self.number - 20;
            self.askForData()
        },cancel: {
            self.back()
        })
    }


    private func askForData() {
        if (isThereNext) {
            isQuering = true
            isThereNext = false
            provider.search(searchQuery, more: number)
            number = number + 20
        }
    }

    func searchedItems(_ array: Array<SearchElementProtocol>) {
        self.refreshControl?.endRefreshing()
        isQuering = false
        self.array = self.array + array
        self.tableView.reloadData();
    }



    func back() {
        self.navigationController?.popViewController(animated: true)
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
                askForData()
            }
        }
    }

}
