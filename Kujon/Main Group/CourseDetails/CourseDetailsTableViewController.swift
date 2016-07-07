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
        NavigationMenuCreator.createNavMenuWithBackButton(self,selector: #selector(CourseDetailsTableViewController.back),andTitle: "Szczegóły Przedmiotu")
        courseDetailsProvider.delegate = self;
        if(course != nil ) {
            courseDetailsProvider.loadCourseDetails(course)
        }else if( courseId != nil && termId != nil){
            courseDetailsProvider.loadCourseDetails(courseId,andTermId: termId)

        }else{
            back()
        }
        for section in sectionHelpers{
            section.registerView(self.tableView)
        }
    }

    private func createSections()->Array<SectionHelperProtocol>{
        return [NameSection(),FacultieSection(),DescriptionSection(),BibliographySection()
                ,PassCriteriaSection(),CycleSection(),LecturersSection(),CoordinatorsSection(),ClassTypeSection(),ParticipantsSection()]
    }
    func back(){

        self.navigationController?.popViewControllerAnimated(true)
    }

    func onCourseDetailsLoaded(courseDetails: CourseDetails) {
        sectionHelpers = createSections()
        for sectionHelper in sectionHelpers{
            sectionHelper.registerView(self.tableView)
            sectionHelper.fillUpWithData(courseDetails)
        }
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
        self.showAlertApiError({
            if(self.course != nil ) {
                self.courseDetailsProvider.loadCourseDetails(self.course)
            }else if( self.courseId != nil && self.termId != nil){
                self.courseDetailsProvider.loadCourseDetails(self.courseId,andTermId: self.termId)
            }
        },cancelFucnt: {
            self.back()
        })
    }




    // MARK: - Table view data source

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sectionHelpers[section] as! SectionHelperProtocol).getSectionHeaderHeight()
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createLabelForSectionTitle((sectionHelpers[section] as! SectionHelperProtocol).getSectionTitle())
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionHelpers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (sectionHelpers[section] as! SectionHelperProtocol).getSectionSize()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let helper = (sectionHelpers[indexPath.section] as! SectionHelperProtocol)
        return helper.giveMeCellAtPosition(tableView,onPosition: indexPath)
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat((sectionHelpers[indexPath.section] as! SectionHelperProtocol).getRowHeight())
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        (sectionHelpers[indexPath.section] as! SectionHelperProtocol).reactOnSectionClick(indexPath.row,withController: self.navigationController)
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
