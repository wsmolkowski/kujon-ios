//
//  TeacherDetailTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 16/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherDetailTableViewController: UITableViewController, UserDetailsProviderDelegate, OnImageLoadedFromRest {
    private let TeacherDetailViewId = "teacherDetailViewId"
    var teacherId: String! = nil
    var simpleUser:SimpleUser! = nil
    private let userDetailsProvider = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    private let restImageProvider = RestImageProvider.sharedInstance
    private var userDetails: UserDetail! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(TeacherDetailTableViewController.back), andTitle: StringHolder.lecturer)
        self.tableView.registerNib(UINib(nibName: "TeacherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: TeacherDetailViewId)
        userDetailsProvider.delegate = self
        self.tableView.tableFooterView = UIView()
        if(simpleUser != nil){
            userDetailsProvider.loadUserDetail(simpleUser.id!)
        }else{

            let currentTeacher = CurrentTeacherHolder.sharedInstance
            userDetailsProvider.loadUserDetail(currentTeacher.currentTeacher.id!)
        }

    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        self.userDetails = userDetails
        self.tableView.reloadData()
    }

    func onErrorOccurs() {
    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 400
            break;
        default: return 50
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDetails == nil ? 0 : 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section) {
        case 0: cell = self.configureTeacherDetails(indexPath)
            break;
        default: cell = self.configureTeacherDetails(indexPath)
        }

        return cell
    }
    private var isThereImage = false
    private func configureTeacherDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeacherDetailViewId, forIndexPath: indexPath) as! TeacherDetailsTableViewCell
        cell.teacherNameLabel.text = getPrefix(self.userDetails.titles) + " " + self.userDetails.firstName + " " + self.userDetails.lastName + " " + getSuffix(self.userDetails.titles)
        cell.teacherStatusLabel.text = self.userDetails.staffStatus
        cell.teacherEmailLabel.text = self.userDetails.email
        cell.teacherConsultationLabel.text = self.userDetails.officeHours
        cell.teacherHomepageLabel.text = self.userDetails.homepage
        cell.teacherImageView.makeMyselfCircle()
        cell.teacherImageView.image = UIImage(named: "user-placeholder")
        if (userDetails.hasPhoto) {
            restImageProvider.loadImage("", urlString: userDetails.photoUrl!, onImageLoaded: self)
        }
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.teacherImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.teacherImageView.userInteractionEnabled = true

        return cell
    }


    func imageTapped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: NSBundle.mainBundle())
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TeacherDetailsTableViewCell
            imageController.image = cell.teacherImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture , forDuration: 2.0)
        }
    }

    func imageLoaded(tag: String, image: UIImage) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TeacherDetailsTableViewCell
        cell.teacherImageView.image = image
        isThereImage = true
    }

    private func getPrefix(title: Title) -> String {
        return title.before != nil ? title.before : ""
    }

    private func getSuffix(title: Title) -> String {
        return title.after != nil ? title.after : ""
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
