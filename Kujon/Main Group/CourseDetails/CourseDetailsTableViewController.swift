//
//  CourseDetailsTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 29/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CourseDetailsTableViewController: UITableViewController,CourseDetailsProviderDelegate {

    var sectionHelpers:Array<SectionHelperProtocol> = []
    var course:Course! = nil;
    var courseId:String! = nil;
    var termId:String! = nil;
    let courseDetailsProvider  = ProvidersProviderImpl.sharedInstance.provideCourseDetailsProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(CourseDetailsTableViewController.back),andTitle: StringHolder.courseDetails)
        courseDetailsProvider.delegate = self;
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(CourseDetailsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.beginRefreshingManually()
        load()
        for section in sectionHelpers{
            section.registerView(self.tableView)
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        courseDetailsProvider.reload()
        load()

    }

    fileprivate func load(){
        if(course != nil ) {
            courseDetailsProvider.loadCourseDetails(course)
        }else if( courseId != nil && termId != nil){
            courseDetailsProvider.loadCourseDetails(courseId,andTermId: termId)

        }else if (courseId != nil && termId == nil){
            courseDetailsProvider.loadCourseDetails(courseId)

        }else{
            back()
        }
    }
    fileprivate func createSections()->Array<SectionHelperProtocol>{
        return [NameSection(),FacultieSection(),DescriptionSection(),BibliographySection()
                ,PassCriteriaSection(),CycleSection(),LecturersSection(),CoordinatorsSection(),ClassTypeSection(),ParticipantsSection()]
    }
    func back(){

        self.navigationController?.popViewController(animated: true)
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





    // MARK: - Table view data source

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sectionHelpers[section]).getSectionHeaderHeight()
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createLabelForSectionTitle((sectionHelpers[section]).getSectionTitle())
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
        let helper = (sectionHelpers[(indexPath as NSIndexPath).section] )
        let cell = helper.giveMeCellAtPosition(tableView,onPosition: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return  cell!
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((sectionHelpers[(indexPath as NSIndexPath).section] ).getRowHeight())
    }

    @available(iOS 2.0, *) override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (sectionHelpers[(indexPath as NSIndexPath).section]).reactOnSectionClick((indexPath as NSIndexPath).row,withController: self.navigationController)
    }

}
