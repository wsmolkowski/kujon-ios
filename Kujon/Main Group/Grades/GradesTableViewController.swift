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
    fileprivate let GradeCellIdentiefer = "GradeCellId"
    let textId = "myTextSuperId"
    fileprivate var myTermGrades  = Array<PreparedTermGrades>()
    fileprivate var dataBack = false;

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(GradesTableViewController.openDrawer),andTitle: StringHolder.grades)
        gradesProvider.delegate = self
        self.tableView.register(UINib(nibName: "Grade2TableViewCell", bundle: nil), forCellReuseIdentifier: GradeCellIdentiefer)
        gradesProvider.loadGrades()
        self.tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(GradesTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.beginRefreshingManually()
        dataBack = false;
    }
    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        gradesProvider.reload()
        gradesProvider.loadGrades()

    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }

    func onGradesLoaded(_ termGrades: Array<PreparedTermGrades>) {
        dataBack = true
        self.myTermGrades = termGrades
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.gradesProvider.reload()
            self.gradesProvider.loadGrades()
        }, cancel: {
            self.refreshControl?.endRefreshing()
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return noDataCondition() ? 1:self.myTermGrades.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(noDataCondition()){
            return 1
        }
        return self.myTermGrades[section].grades.count
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(noDataCondition()){
            return 0
        }
        return 50
    }


    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(noDataCondition()){
            return nil
        }
        return self.createLabelForSectionTitle(self.myTermGrades[section].termId,middle: true)
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(noDataCondition()){
            let cell = UITableViewCell(style: .default, reuseIdentifier: textId)
            cell.textLabel?.font = UIFont.kjnTextStyle2Font()
            if(dataBack){
                cell.textLabel?.text = StringHolder.no_grades
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: GradeCellIdentiefer, for: indexPath) as! Grade2TableViewCell
        let prepareGrade = self.myTermGrades[(indexPath as NSIndexPath).section].grades[(indexPath as NSIndexPath).row] 

        cell.textGradeLabel.text = prepareGrade.grades.valueDescription
        cell.gradeNumberLabel.text = prepareGrade.grades.valueSymbol
        cell.descriptionLabel.text = prepareGrade.courseName
        cell.secDescLabel.text = prepareGrade.grades.getClassType() + "  " + StringHolder.termin  + " " + String(prepareGrade.grades.examSessionNumber)
        cell.layer.addBorder( UIRectEdge.top, color: UIColor.lightGray(), thickness: 1)
        return cell
    }

    fileprivate func noDataCondition()->Bool{
        return self.myTermGrades.count == 0
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prepareGrade = self.myTermGrades[(indexPath as NSIndexPath).section].grades[(indexPath as NSIndexPath).row] 

        let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
        courseDetails.courseId = prepareGrade.courseId
        courseDetails.termId = prepareGrade.termId
        self.navigationController?.pushViewController(courseDetails, animated: true)
    }


}
