//
//  CourseDetailsTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 29/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CourseDetailsTableViewController: RefreshingTableViewController,CourseDetailsProviderDelegate {

    var sectionHelpers:Array<SectionHelperProtocol> = []
    var course:Course! = nil;
    var courseId:String! = nil;
    var termId:String! = nil;
    let courseDetailsProvider  = ProvidersProviderImpl.sharedInstance.provideCourseDetailsProvider()

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
                CourseMeritsSection(),
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

    func onErrorOccurs(_ text: String) {
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
        // #warning Incomplete implementation, return the number of sections
        return sectionHelpers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (sectionHelpers[section]).getSectionSize()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helper = (sectionHelpers[indexPath.section])
        let cell = helper.giveMeCellAtPosition(tableView,onPosition: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return  cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (sectionHelpers[indexPath.section]).reactOnSectionClick(indexPath.row,withController: self.navigationController)
    }

}
