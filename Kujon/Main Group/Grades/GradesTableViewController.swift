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
    let gradesProvider = ProvidersProviderImpl.sharedInstance.provideGradesProvider()
    private let GradeCellIdentiefer = "GradeCellId"

    private var myTermGrades  = Array<TermGrades>()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(GradesTableViewController.openDrawer),andTitle: StringHolder.grades)
        gradesProvider.delegate = self
        gradesProvider.test = true
        self.tableView.registerNib(UINib(nibName: "GradesTableViewCell", bundle: nil), forCellReuseIdentifier: GradeCellIdentiefer)
        gradesProvider.loadGrades()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        gradesProvider.reload()
        gradesProvider.loadGrades()

    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onGradesLoaded(termGrades: Array<TermGrades>) {
        self.myTermGrades = termGrades
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            gradesProvider.reload()
            gradesProvider.loadGrades()
        }, cancel: {})
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


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.createLabelForSectionTitle(self.myTermGrades[section].termId,middle: true)
    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(GradeCellIdentiefer, forIndexPath: indexPath) as! GradesTableViewCell
        let grade = self.myTermGrades[indexPath.section].grades[indexPath.row] as! Grade

        cell.textGradeLabel.text = grade.valueDescription
        cell.gradeNumberLabel.text = grade.valueSymbol
        cell.descriptionLabel.text = grade.courseName
        cell.secDescLabel.text = grade.classType + "  " + StringHolder.termin  + " " + String(grade.examSessionNumber)

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let grade = self.myTermGrades[indexPath.section].grades[indexPath.row] as! Grade

        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: NSBundle.mainBundle())
        courseDetails.courseId = grade.courseId
        courseDetails.termId = grade.termId
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


}
