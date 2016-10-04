//
//  SearchResultTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController,SearchProviderDelegate {


    var array:Array<SearchElementProtocol> = Array()
    var searchQuery: String! = nil
    var provider:SearchProviderProtocol! = nil
    let myCellId = "asjfnainnjagdandgp"


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(SearchResultTableViewController.back), andTitle: StringHolder.search)
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
        if(provider != nil && searchQuery != nil){
            provider.setDelegate(self)
            provider.search(searchQuery)
        }
    }


    func searchedItems(array: Array<SearchElementProtocol>) {
        self.array = array;
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
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = array[indexPath.row].getTitle()
        return cell

    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        array[indexPath.row].reactOnClick(self.navigationController!)
    }


    
}
