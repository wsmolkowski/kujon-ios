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
        self.tableView.register(UINib(nibName: "TeacherHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: TeacherDetailViewId)
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: programmesIdCell)
        userDetailsProvider.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.showsVerticalScrollIndicator = false
        loadUser()

        self.tableView.estimatedRowHeight = 6000


        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(TeacherDetailTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    override func viewDidAppear(_ animated: Bool) {
        if self.isBeingPresented || self.isMovingToParentViewController {
            refreshControl?.beginRefreshingManually()
        }
    }

    func back() {
        self.navigationController?.popViewController(animated: true)
    }


    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        userDetailsProvider.reload()
        loadUser()
    }

    func onUserDetailLoaded(_ userDetails: UserDetail) {
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

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.loadUser()
        }, cancel: {})
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 576
        default: return 50
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return userDetails == nil ? 0 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section){
            case 0: return userDetails == nil ? 0 : 1
            case 1: return userDetails?.courseEditionsConducted == nil ? 0 : userDetails.courseEditionsConducted!.count
        default: return 0
        }

    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 1:
            self.clicked(indexPath.row)
            break;
        default:
            break;
        }
    }

    private func clicked(_ pos:Int){
        let coursEdition = self.userDetails!.courseEditionsConducted?[pos]
        if(coursEdition != nil){
            let courseDetails = CourseDetailsTableViewController(nibName: "CourseDetailsTableViewController", bundle: Bundle.main)
            courseDetails.courseId = coursEdition!.courseId
            courseDetails.termId = coursEdition!.termId
            self.navigationController?.pushViewController(courseDetails, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0: return 0

        default: return 51
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0: return nil
        case 1: return createLabelForSectionTitle(StringHolder.lecturesConducted)
        default: return nil
        }
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch (indexPath.section) {
        case 0: cell = self.configureTeacherDetails(indexPath)
            break;
        case 1: cell = self.configureTeacherCourse(indexPath)
            break;
        default: cell = self.configureTeacherDetails(indexPath)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

    private var isThereImage = false

    private func configureTeacherDetails(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherDetailViewId, for: indexPath) as! TeacherHeaderTableViewCell
        cell.teacherNameLabel.text = getPrefix(self.userDetails.titles) + " " + self.userDetails.firstName + " " + self.userDetails.lastName + " " + getSuffix(self.userDetails.titles)
        cell.teacherStatusLabel.text = self.userDetails.staffStatus
        cell.teacherEmailURL = userDetails.emailUrl
        cell.teacherConsultationLabel.text = self.userDetails.officeHours
        if(self.userDetails.homepage != nil){
            let tapWWW = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.wwwTaped))
            tapWWW.numberOfTapsRequired = 1
            cell.teacherHomepageLabel.addGestureRecognizer(tapWWW)
            cell.teacherHomepageLabel.isUserInteractionEnabled = true
        }
        cell.teacherHomepageLabel.text = self.userDetails.homepage
        cell.teacherImageView.makeMyselfCircle()
        cell.teacherImageView.image = UIImage(named: "user-placeholder")

        if(self.userDetails.room  != nil){
            cell.teacherRoomLabel.text = self.userDetails.room!.getRoomString()
        }

        if (userDetails.photoUrl != nil) {
            restImageProvider.loadImage("", urlString: userDetails.photoUrl!, onImageLoaded: self)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TeacherDetailTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.teacherImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.teacherImageView.isUserInteractionEnabled = true
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }


    func configureTeacherCourse(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: programmesIdCell, for: indexPath) as! GoFurtherViewCellTableViewCell
        let courseEdition = self.userDetails?.courseEditionsConducted?[indexPath.row]
        if (courseEdition != nil){
            cell.plainLabel.text = courseEdition!.courseName + "(" + courseEdition!.termId + ")"
        }
        return cell
    }


    func imageTapped(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if (isThereImage) {
            let imageController = ImageViewController(nibName: "ImageViewController", bundle: Bundle.main)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TeacherHeaderTableViewCell
            imageController.image = cell.teacherImageView.image
            self.navigationController?.pushViewController(imageController, animated: true)
        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture , forDuration: 2.0)
        }
    }

    func wwwTaped(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        if let url = URL(string: self.userDetails.homepage != nil ? self.userDetails.homepage! : "") {
            UIApplication.shared.openURL(url)
        }
    }

    func imageLoaded(_ tag: String, image: UIImage) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TeacherHeaderTableViewCell
        cell.teacherImageView.image = image
        isThereImage = true
    }

    private func getPrefix(_ title: Title) -> String {
        return title.before != nil ? title.before : ""
    }

    private func getSuffix(_ title: Title) -> String {
        return title.after != nil ? title.after : ""
    }

}
