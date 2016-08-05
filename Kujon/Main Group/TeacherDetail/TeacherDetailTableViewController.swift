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
        self.tableView.showsVerticalScrollIndicator = false
        loadUser()

        self.tableView.estimatedRowHeight = 6000


        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

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
        }else{

            let currentTeacher = CurrentTeacherHolder.sharedInstance
            userDetailsProvider.loadUserDetail(currentTeacher.currentTeacher.id!)
        }
    }

    func onErrorOccurs(text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            loadUser()
        }, cancel: {})
    }

    @available(iOS 2.0, *) override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 460
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }
    private var isThereImage = false
    private func configureTeacherDetails(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TeacherDetailViewId, forIndexPath: indexPath) as! TeacherDetailsTableViewCell
        cell.teacherNameLabel.text = getPrefix(self.userDetails.titles) + " " + self.userDetails.firstName + " " + self.userDetails.lastName + " " + getSuffix(self.userDetails.titles)
        cell.teacherStatusLabel.text = self.userDetails.staffStatus
        cell.teacherEmailLabel.text = self.userDetails.email
        cell.teacherConsultationLabel.text = self.userDetails.officeHours
        if(self.userDetails.homepage != nil){
            var tapWWW = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.wwwTaped))
            tapWWW.numberOfTapsRequired = 1
            cell.teacherHomepageLabel.addGestureRecognizer(tapWWW)
            cell.teacherHomepageLabel.userInteractionEnabled = true
        }
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

    func wwwTaped(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if let url = NSURL(string: self.userDetails.homepage) {
            UIApplication.sharedApplication().openURL(url)
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

}
