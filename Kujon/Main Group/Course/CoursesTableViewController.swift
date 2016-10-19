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
        
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(CoursesTableViewController.openDrawer),andTitle: StringHolder.courses)
        self.tableView.register(UINib(nibName: "CourseTableViewCell", bundle: nil), forCellReuseIdentifier: CourseCellId)
        courseProvider.delegate = self
        courseProvider.provideCourses()
        self.tableView.tableFooterView = UIView()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(CoursesTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.beginRefreshingManually()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140

    }

    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        courseProvider.reload()
        courseProvider.provideCourses()

    }

    func coursesProvided(_ courses: Array<CoursesWrapper>) {

        self.courseWrappers = courses;
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()

    }

    func onErrorOccurs() {

    }

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return courseWrappers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseWrappers[section].courses.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course
        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.course = course
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCellId, for: indexPath) as! CourseTableViewCell
        let course = self.courseWrappers[indexPath.section].courses[indexPath.row]  as Course

        cell.courseNameLabel.text = course.courseName
        cell.selectionStyle = UITableViewCellSelectionStyle.none


        return cell
    }



    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 48
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createLabelForSectionTitle(self.courseWrappers[section].title,middle: true)
    }


    
}
