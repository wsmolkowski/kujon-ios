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

    private var myTermGrades  = Array<PreparedTermGrades>()

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(GradesTableViewController.openDrawer),andTitle: StringHolder.grades)
        gradesProvider.delegate = self
        self.tableView.registerNib(UINib(nibName: "Grade2TableViewCell", bundle: nil), forCellReuseIdentifier: GradeCellIdentiefer)
        gradesProvider.loadGrades()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(GradesTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        gradesProvider.reload()
        gradesProvider.loadGrades()

    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onGradesLoaded(termGrades: Array<PreparedTermGrades>) {
        self.myTermGrades = termGrades
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.gradesProvider.reload()
            self.gradesProvider.loadGrades()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(GradeCellIdentiefer, forIndexPath: indexPath) as! Grade2TableViewCell
        let prepareGrade = self.myTermGrades[indexPath.section].grades[indexPath.row] 

        cell.textGradeLabel.text = prepareGrade.grades.valueDescription
        cell.gradeNumberLabel.text = prepareGrade.grades.valueSymbol
        cell.descriptionLabel.text = prepareGrade.courseName
        cell.secDescLabel.text = prepareGrade.grades.classType + "  " + StringHolder.termin  + " " + String(prepareGrade.grades.examSessionNumber)

        return cell
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let prepareGrade = self.myTermGrades[indexPath.section].grades[indexPath.row] 

        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: NSBundle.mainBundle())
        courseDetails.courseId = prepareGrade.courseId
        courseDetails.termId = prepareGrade.termId
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


}
