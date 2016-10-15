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
        self.tableView.register(UINib(nibName: "TermsTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }
    func setUpTerms(_ terms:Array<Term>){
        self.terms = terms
        self.tableView.reloadData()
    }

    func back(){
        self.navigationController?.popViewController(animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return terms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TermsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TermsTableViewCell
        let term: Term = self.terms[(indexPath as NSIndexPath).row]

        cell.endDateLabel.text = term.endDate
        cell.endDateLabel.adjustsFontSizeToFitWidth = true

        cell.endindTimeLabel.text = term.finishDate
        cell.endindTimeLabel.adjustsFontSizeToFitWidth = true
        cell.startDateLabel.text = term.startDate
        cell.startDateLabel.adjustsFontSizeToFitWidth = true
        cell.termActiveLabel.text = term.active ? StringHolder.yes:StringHolder.no
        cell.termNameLabel.text = term.name
        cell.termNumberLabel.text = term.termId
        return cell
    }


    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }


}
