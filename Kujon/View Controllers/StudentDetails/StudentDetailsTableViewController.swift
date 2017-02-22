//
//  StudentDetailsTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 17/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class StudentDetailsTableViewController: RefreshingTableViewController, UserDetailsProviderDelegate, OnImageLoadedFromRest, ProgrammeIdProviderDelegate {

    let kierunekCellId = "kierunekCellId"
    let headerCellId = "studentHeaderCellId"

    let restImageProvider = RestImageProvider.sharedInstance
    var provider = ProvidersProviderImpl.sharedInstance.provideUserDetailsProvider()
    var programmeProvider = ProvidersProviderImpl.sharedInstance.provideProgrammeId()
    var user: SimpleUser! = nil
    var studentProgrammes: Array<StudentProgramme> = Array()
    var userDetails: UserDetail! = nil
    var userId: String! = nil
    var isImageLoaded = false
    var isImageRequested: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(StudentDetailsTableViewController.back))
        title = StringHolder.student
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: kierunekCellId)
        self.tableView.register(UINib(nibName: "StudentHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        self.tableView.separatorStyle = .none
        if (userId == nil) {
            userId = user.userId
        }
        programmeProvider.delegate = self
        provider.delegate = self
        addToProvidersList(provider: provider)
      }

    func back() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func loadData() {
        provider.loadUserDetail(userId)
    }

    func onUserDetailLoaded(_ userDetails: UserDetail) {
        self.refreshControl?.endRefreshing()
        self.userDetails = userDetails;
        self.studentProgrammes = Array()
        for programmess in userDetails.studentProgrammes {
            programmeProvider.loadProgramme((programmess as StudentProgramme).programme.id)
        }
        self.tableView.reloadData()
    }


    func onProgrammeLoaded(_ id: String, programme: StudentProgramme) {
        self.studentProgrammes.append(programme)
        self.tableView.reloadData()
    }

    func onUsosDown() {
        self.refreshControl?.endRefreshing()
        EmptyStateView.showUsosDownAlert(inParent: view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.userDetails != nil ? 2 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return self.userDetails != nil ? 1 : 0
        case 1: return studentProgrammes.count
        default: return 0
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0: return 216
        default: return 50
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0: return self.studentCellConfigure(indexPath)
        case 1: return self.configureStudentProgrammeCell(indexPath)
        default: return self.configureStudentProgrammeCell(indexPath)
        }
    }

    private func studentCellConfigure(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! StudentHeaderTableViewCell
        cell.studentImageView.image = UIImage(named: "user-placeholder")
        if self.userDetails.photoUrl != nil && isImageRequested == false{
            self.restImageProvider.loadImage("", urlString: self.userDetails.photoUrl!, onImageLoaded: self)
            isImageRequested = true

        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StudentDetailsTableViewController.imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell.studentImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.studentImageView.isUserInteractionEnabled = true
        cell.studentNameLabel.text = self.userDetails.firstName + " " + userDetails.lastName
        cell.studentStatusLabel.text = self.userDetails.studentStatus
        cell.studentAccountLabel.text = self.userDetails.id
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    private func configureStudentProgrammeCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kierunekCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let myProgramme: StudentProgramme = self.studentProgrammes[indexPath.row]
        cell.plainLabel.text = myProgramme.programme.description
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }


    func imageLoaded(_ tag: String, image: UIImage) {
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) {
            (cell as! StudentHeaderTableViewCell).studentImageView.image = image
            (cell as! StudentHeaderTableViewCell).studentImageView.makeMyselfCircle()
            isImageLoaded = true
        }

    }

    func imageTapped(_ sender: UITapGestureRecognizer) {
        print(sender.view?.tag as Any)
        if (isImageLoaded) {
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) {
                let imageController = ImageViewController(nibName: "ImageViewController", bundle: Bundle.main)
                imageController.image = (cell as! StudentHeaderTableViewCell).studentImageView.image
                self.navigationController?.pushViewController(imageController, animated: true)
            }

        } else {


            ToastView.showInParent(self.navigationController?.view, withText: StringHolder.noPicture, forDuration: 2.0)
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
        case 1: return createLabelForSectionTitle(StringHolder.kierunki)
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 1:
            self.clicked(indexPath)
            break;
        default:
            break;
        }
    }

    func clicked(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let programme: Programme = self?.studentProgrammes[indexPath.row].programme else {
                return
            }
            let kierunekDetailController = KierunekDetailViewController()
            kierunekDetailController.programme = programme
            self?.navigationController?.pushViewController(kierunekDetailController, animated: true)
        }
    }

}
