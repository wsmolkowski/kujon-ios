//
//  CoursesTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController, NavigationDelegate,CourseProviderDelegate {
    private let CourseCellId = "courseCellId"
    private let courseProvider = ProvidersProviderImpl.sharedInstance.provideCourseProvider()
    private var courseWrappers = Array<CoursesWrapper>()
    weak var delegate: NavigationMenuProtocol! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CoursesTableViewController.openDrawer),andTitle: "Przedmioty")
        self.tableView.registerNib(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseCellId)
        courseProvider.delegate = self
        courseProvider.provideCourses()

    }

    func coursesProvided(courses: Array<CoursesWrapper>) {
        self.courseWrappers = courses;
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return courseWrappers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseWrappers[section].courses.count
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: NSBundle.mainBundle())
        courseDetails.course = course
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CourseCellId, forIndexPath: indexPath) as! CourseTableViewCell
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course

        cell.courseNameLabel.text = course.courseName
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the cell...

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 48
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createLabel(self.courseWrappers[section].title)
    }

    private func createLabel(text: String) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 56))
        let label = UILabel(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 48))
        label.text = text
        label.textColor = UIColor.blackWithAlpha()
        view.addSubview(label)
        return view
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
