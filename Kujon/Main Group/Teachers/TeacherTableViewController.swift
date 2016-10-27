//
//  TeacherTableViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 13/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherTableViewController: UITableViewController, NavigationDelegate, LecturerProviderDelegate {
    private let TeachCellId = "teacherCellId"
    weak var delegate: NavigationMenuProtocol! = nil
    let lecturerProvider = ProvidersProviderImpl.sharedInstance.provideLecturerProvider()
    private var lecturers: Array<SimpleUser>! = nil

    func setNavigationProtocol(_ delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(TeacherTableViewController.openDrawer),andTitle: StringHolder.lecturers)
        self.tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: TeachCellId)
        lecturerProvider.delegate = self
        lecturerProvider.loadLecturers()
        self.tableView.tableFooterView = UIView()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(TeacherTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func viewDidAppear(_ animated: Bool) {
        refreshControl?.beginRefreshingManually()
    }

    func refresh(_ refreshControl: UIRefreshControl) {
        NSlogManager.showLog("Refresh was called")
        lecturerProvider.reload()
        lecturerProvider.loadLecturers()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }


    func onLecturersLoaded(_ lecturers: Array<SimpleUser>) {
        self.lecturers = lecturers
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func onErrorOccurs(_ text: String) {
        self.showAlertApi(StringHolder.attention, text: text, succes: {
            self.lecturerProvider.reload()
            self.lecturerProvider.loadLecturers()
            }, cancel: {})
    }


    func openDrawer() {
        delegate?.toggleLeftPanel()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.lecturers != nil) {
            return self.lecturers.count
        } else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoFurtherViewCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: TeachCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let myUser: SimpleUser = self.lecturers[indexPath.row]
        cell.plainLabel.text = myUser.lastName + " " + myUser.firstName
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.connected(indexPath)
    }


    func connected(_ indexPath: IndexPath) {
        guard indexPath.row < lecturers.count else {
            return
        }
        let myUser: SimpleUser = self.lecturers[indexPath.row]
        let currentTeacher  = CurrentTeacherHolder.sharedInstance
        currentTeacher.currentTeacher = myUser
        let controller = TeacherDetailTableViewController()
        controller.simpleUser = myUser
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
