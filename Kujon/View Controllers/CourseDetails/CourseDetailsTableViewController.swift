//
//  CourseDetailsTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 29/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol CourseDetailsTableViewControllerDelegate: class {

    func courseDetailsTableViewController(_ controller: CourseDetailsTableViewController, didUpdateFilesCount count: Int, forCourseId courseId: String, andTermId termId: String)
}

class CourseDetailsTableViewController: RefreshingTableViewController, CourseDetailsProviderDelegate, SharedFilesViewControllerDelegate, CourseMeritsTableViewCellDelegate {

    var sectionHelpers:Array<SectionHelperProtocol> = []
    var course:Course! = nil;
    var courseId:String! = nil;
    var termId:String! = nil;
    let courseDetailsProvider  = ProvidersProviderImpl.sharedInstance.provideCourseDetailsProvider()
    weak var delegate: CourseDetailsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(CourseDetailsTableViewController.back),andTitle: StringHolder.courseDetails)
        courseDetailsProvider.delegate = self
        addToProvidersList(provider:courseDetailsProvider)
        for section in sectionHelpers{
            section.registerView(self.tableView)
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

    }

    override func loadData() {
        if(course != nil ) {
            courseDetailsProvider.loadCourseDetails(course)
        } else if( courseId != nil && termId != nil){
            courseDetailsProvider.loadCourseDetails(courseId,andTermId: termId)

        } else if (courseId != nil && termId == nil){
            courseDetailsProvider.loadCourseDetails(courseId)
            
        } else {
            back()
        }
    }

    private func createSections()->Array<SectionHelperProtocol>{
        return [NameSection(),
                SharedFilesSection(),
                FacultieSection(),
                CourseMeritsDescriptionSection(),
                CourseMeritsBibliographySection(),
                CourseMeritsAssessemntSection(),
                CycleSection(),
                LecturersSection(),
                CoordinatorsSection(),
                ClassTypeSection(),
                ParticipantsSection()]
    }

    func back(){
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func onCourseDetailsLoaded(_ courseDetails: CourseDetails) {
        sectionHelpers = createSections()
        for sectionHelper in sectionHelpers{
            sectionHelper.registerView(self.tableView)
            sectionHelper.fillUpWithData(courseDetails)
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }


    func onErrorOccurs(_ text: String, retry: Bool) {

        if retry {
            loadData()
            return
        }

        self.showAlertApi(StringHolder.attention,text:text,succes:{
            if(self.course != nil ) {
                self.courseDetailsProvider.loadCourseDetails(self.course)
            }else if( self.courseId != nil && self.termId != nil){
                self.courseDetailsProvider.loadCourseDetails(self.courseId,andTermId: self.termId)
            }
        },cancel: {
            self.back()
        })
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  (sectionHelpers[section]).sectionHeaderHeight()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionTitle = sectionHelpers[section].getSectionTitle() {
            return createLabelForSectionTitle(sectionTitle)
        }
        return nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHelpers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionHelpers[section]).getSectionSize()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helper = (sectionHelpers[indexPath.section])
        let cell = helper.giveMeCellAtPosition(tableView,onPosition: indexPath)
        (cell as? CourseMeritsTableViewCell)?.delegate = self
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return  cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (sectionHelpers[indexPath.section]).reactOnSectionClick(indexPath.row,withController: self.navigationController, setDelegate: self)
    }


    // MARK: - SharedFilesViewControllerDelegate

    func sharedFilesViewController(_ controller: SharedFilesViewController, didUpdateFilesCount count: Int, forCourseId courseId: String, andTermId termId: String) {
        if let sharedFilesSection = sectionHelpers.filter({ $0 is SharedFilesSection }).first as? SharedFilesSection {
            sharedFilesSection.updateFilesCount(count)
            tableView.reloadData()
            delegate?.courseDetailsTableViewController(self, didUpdateFilesCount: count, forCourseId: courseId, andTermId: termId)
        }
    }

    // MARK: - CourseMeritsTableViewCellDelegate

    func courseMeritsCellDidChangeContent(_ cell: CourseMeritsTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
