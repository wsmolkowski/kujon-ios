//
//  ThesesTableViewController.swift
//  Kujon
//
//  Created by Adam on 06.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesesTableViewController: UITableViewController {

    var theses: [Thesis]?
    private let cellId = "ThesisCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.theses
        setupTableView()
    }

    private func setupTableView() {
        tableView.registerNib(UINib(nibName: "ThesisCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .None
        tableView.backgroundColor = .lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        theses = nil;
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theses?.count ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ThesisCell
        cell.thesis = theses?[indexPath.row]
        return cell
    }

}
