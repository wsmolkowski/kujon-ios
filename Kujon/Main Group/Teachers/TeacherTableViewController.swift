//
//  TeacherTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 13/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherTableViewController: UITableViewController, NavigationDelegate, LecturerProviderDelegate {
    private let TeachCellId = "teacherCellId"
    weak var delegate: NavigationMenuProtocol! = nil
    let lecturerProvider = ProvidersProviderImpl.sharedInstance.provideLecturerProvider()
    private var lecturers: Array<SimpleUser>! = nil

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(TeacherTableViewController.openDrawer),andTitle: "Wykładowcy")
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: TeachCellId)
        lecturerProvider.delegate = self
        lecturerProvider.loadLecturers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onLecturersLoaded(lecturers: Array<SimpleUser>) {
        self.lecturers = lecturers
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.lecturers != nil) {
            return self.lecturers.count
        } else {
            return 0
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: GoFurtherViewCellTableViewCell = tableView.dequeueReusableCellWithIdentifier(TeachCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let myUser: SimpleUser = self.lecturers[indexPath.row]
        cell.plainLabel.text = myUser.firstName + " " + myUser.lastName
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.connected(indexPath)
    }


    func connected( indexPath: NSIndexPath) {

        if let myUser: SimpleUser = self.lecturers[indexPath.row] {
            let currentTeacher  = CurrentTeacherHolder.sharedInstance
            currentTeacher.currentTeacher = myUser
            let controller = TeacherDetailTableViewController()
            controller.simpleUser = myUser

            self.navigationController?.pushViewController(controller, animated: true)


        }
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
