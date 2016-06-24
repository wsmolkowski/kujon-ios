//
//  GradesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 24/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class GradesTableViewController: UITableViewController
        , NavigationDelegate
        ,GradesProviderDelegate{

    weak var delegate: NavigationMenuProtocol! = nil
    let gradesProvider = GradesProvider.sharedInstance
    private let GradeCellIdentiefer = "GradeCellId"

    private var myTermGrades  = Array<TermGrades>()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(GradesTableViewController.openDrawer))
        gradesProvider.delegate = self
        gradesProvider.test = true
        self.tableView.registerNib(UINib(nibName: "GradesTableViewCell", bundle: nil), forCellReuseIdentifier: GradeCellIdentiefer)
        gradesProvider.loadGrades()
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onGradesLoaded(termGrades: Array<TermGrades>) {
        self.myTermGrades = termGrades
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.myTermGrades.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myTermGrades[section].grades.count
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.myTermGrades[section].termId
    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(GradeCellIdentiefer, forIndexPath: indexPath) as! GradesTableViewCell
        let grade = self.myTermGrades[indexPath.section].grades[indexPath.row] as! Grade

        cell.textGradeLabel.text = grade.valueDescription
        cell.gradeNumberLabel.text = grade.valueSymbol
        cell.descriptionLabel.text = grade.courseName
        cell.secDescLabel.text = grade.classType + " termin: " + String(grade.examSessionNumber)

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
