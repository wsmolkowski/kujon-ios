//
//  SearchTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,NavigationDelegate {


    let array: Array<SearchViewProtocol> = [UserSearchElement(), CourseSearchElement()]
    weak var delegate: NavigationMenuProtocol! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(SearchTableViewController.openDrawer), andTitle: StringHolder.search)
        super.didReceiveMemoryWarning()
        for cell in array{
            cell.registerView(self.tableView)
        }
    }
    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = array[indexPath.row].provideUITableViewCell(tableView, cellForRowAtIndexPath: indexPath)
        cell.button.tag = indexPath.row;
        cell.button.addTarget(self, action: #selector(click), forControlEvents: .TouchUpInside)
        return cell
    }

    func click(sender: UIButton) {
        let pos = sender.tag
        var path: NSIndexPath = NSIndexPath(forRow: pos, inSection: 0)
        if let cell = self.tableView.cellForRowAtIndexPath(path) {
            let searchCell = cell as! SearchTableViewCell
            let textQuery = searchCell.textView.text
            if (textQuery!.characters.count < 4) {

            }else {
                let controller = SearchResultTableViewController(nibName: "SearchResultTableViewController", bundle: NSBundle.mainBundle())
                controller.provider = array[pos].provideSearchProtocol()
                controller.searchQuery = textQuery!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }

    }


}
