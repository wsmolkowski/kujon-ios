//
// Created by Wojciech Maciejewski on 12/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit


class TermsTableViewController:UITableViewController {

    var terms:Array<Term> = Array()
    let cellId = "termCellSuperId"
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(TermsTableViewController.back),andTitle: StringHolder.terms)
        self.tableView.registerNib(UINib(nibName: "TermsTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }
    func setUpTerms(terms:Array<Term>){
        self.terms = terms
        self.tableView.reloadData()
    }

    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return terms.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TermsTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! TermsTableViewCell
        let term: Term = self.terms[indexPath.row]

        cell.endDateLabel.text = term.endDate
        cell.endindTimeLabel.text = term.finishDate
        cell.startDateLabel.text = term.startDate
        cell.termActiveLabel.text = term.active ? StringHolder.yes:StringHolder.no
        cell.termNameLabel.text = term.name
        cell.termNumberLabel.text = term.termId
        return cell
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }


}
