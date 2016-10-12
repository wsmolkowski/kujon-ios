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
    private let programmesIdCell = "tralalaProgrammesCellId"
    var teacherId: String! = nil
    var simpleUser:SimpleUser! = nil
    private let userDetailsProvider = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    private let restImageProvider = RestImageProvider.sharedInstance
    private var userDetails: UserDetail! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(TeacherDetailTableViewController.back), andTitle: StringHolder.lecturer)
        title = StringHolder.teacher
        self.tableView.registerNib(UINib(nibName: "TeacherHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: TeacherDetailViewId)
        self.tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: programmesIdCell)
        userDetailsProvider.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.showsVerticalScrollIndicator = false
        loadUser()

        self.tableView.estimatedRowHeight = 6000


        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(TeacherDetailTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshingManually()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    func refresh(refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        userDetailsProvider.reload()
        loadUser()
    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        self.userDetails = userDetails
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    private func loadUser(){
        if(simpleUser != nil){
            userDetailsProvider.loadUserDetail(simpleUser.id!)
        }else if(teacherId != nil){
            userDetailsProvider.loadUserDetail(teacherId)
        }else{

            let currentTeacher = CurrentTeacherHolder.sharedInstance
            userDetailsProvider.loadUserDetail(currentTeacher.currentTeacher.id!)
        }
    }

    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.loadUser()
        }, cancel: {})
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 576
        default: return 50
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userDetails == nil ? 0 : 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
            case 0: return userDetails == nil ? 0 : 1
            case 1: return userDetails?.courseEditionsConducted == nil ? 0 : userDetails.courseEditionsConducted!.count
        default: return 0
        }

    }


    @available(iOS 2.0, *) override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 1:
            self.clicked(indexPath.row)
            break;
        default:
            break;
        }
    }

    private func clicked(pos:Int){
        let coursEdition = self.userDetails!.courseEditionsConducted?[pos]
        if(coursEdition != nil){
            let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: NSBundle.mainBundle())
            courseDetails.courseId = coursEdition!.courseId
            courseDetails.termId = coursEdition!.termId
            self.navigationController?.pushViewController(courseDetails, animated: true)
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0

        default: return 51
        }
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
        case 1: return createLabelForSectionTitle(StringHolder.lecturesConducted)
        default: return nil
        }
    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section) {
        case 0: cell = self.configureTeacherDetails(indexPath)
            break;
        case 1: cell = self.configureTeacherCourse(indexPath)
            break;
        default: cell = self.configureTeacherDetails(indexPath)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    private var isThereImage = false

    private func configureTeacherDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeacherDetailViewId, forIndexPath: indexPath) as! TeacherHeaderTableViewCell
        cell.teacherNameLabel.text = getPrefix(self.userDetails.titles) + " " + self.userDetails.firstName + " " + self.userDetails.lastName + " " + getSuffix(self.userDetails.titles)
        cell.teacherStatusLabel.text = self.userDetails.staffStatus
        cell.teacherEmailLabel.text = self.userDetails.email
        cell.teacherEmailURL = userDetails.emailUrl
        cell.teacherConsultationLabel.text = self.userDetails.officeHours
        if(self.userDetails.homepage != nil){
            let tapWWW = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.wwwTaped))
            tapWWW.numberOfTapsRequired = 1
            cell.teacherHomepageLabel.addGestureRecognizer(tapWWW)
            cell.teacherHomepageLabel.userInteractionEnabled = true
        }
        cell.teacherHomepageLabel.text = self.userDetails.homepage
        cell.teacherImageView.makeMyselfCircle()
        cell.teacherImageView.image = UIImage(named: "user-placeholder")

        if(self.userDetails.room  != nil){
            cell.teacherRoomLabel.text = self.userDetails.room!.getRoomString()
        }

        if (userDetails.hasPhoto) {
            restImageProvider.loadImage("", urlString: userDetails.photoUrl!, onImageLoaded: self)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.teacherImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.teacherImageView.userInteractionEnabled = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }


    func configureTeacherCourse(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(programmesIdCell, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let courseEdition = self.userDetails?.courseEditionsConducted?[indexPath.row]
        if (courseEdition != nil){
            cell.plainLabel.text = courseEdition!.courseName
        }
        return cell
    }


    func imageTapped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: NSBundle.mainBundle())
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TeacherHeaderTableViewCell
            imageController.image = cell.teacherImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture , forDuration: 2.0)
        }
    }

    func wwwTaped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if let url = NSURL(string: self.userDetails.homepage != nil ? self.userDetails.homepage! : "") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func imageLoaded(tag: String, image: UIImage) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TeacherHeaderTableViewCell
        cell.teacherImageView.image = image
        isThereImage = true
    }

    private func getPrefix(title: Title) -> String {
        return title.before != nil ? title.before : ""
    }

    private func getSuffix(title: Title) -> String {
        return title.after != nil ? title.after : ""
    }

}
