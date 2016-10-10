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
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "SearchResultsCell", bundle: nil), forCellReuseIdentifier: myCellId)
        if (provider != nil && searchQuery != nil) {
            provider.setDelegate(self)

        }
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(SearchResultTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshingManually()
        askForData()
    }

    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        self.array = Array()
        self.tableView.reloadData();
        number = 0
        askForData()
    }

    func isThereNextPage(isThere: Bool) {
        self.isThereNext = isThere
    }


    private func askForData() {
        if (isThereNext) {
            isQuering = true
            isThereNext = false
            provider.search(searchQuery, more: number)
            number = number + 20
        }
    }

    func searchedItems(array: Array<SearchElementProtocol>) {
        self.refreshControl?.endRefreshing()
        isQuering = false
        self.array = self.array + array
        self.tableView.reloadData();
    }

    func onErrorOccurs(text: String) {
    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchResultsCell
        cell.title = array[indexPath.row].getTitle()
        return cell

    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        array[indexPath.row].reactOnClick(self.navigationController!)
    }
    var isQuering = false
    @available(iOS 2.0, *) override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

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
