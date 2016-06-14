//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol DoOnStudentProgrammeClick {
    func doOnClick(programme: StudentProgramme)
}

class StudentProgrammeTableViewDelegateController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var programmes: Array<StudentProgramme>! = nil
    var clickHandler: DoOnStudentProgrammeClick! = nil
    var tableView: UITableView! = nil

    private let StudentProgrammeCellId = "cellIdForStudentProgramme"


    func setUp(tableView: UITableView, clickListener: DoOnStudentProgrammeClick) {
        self.tableView = tableView;
//        self.tableView.scrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let footer = UILabel(frame:CGRectZero)
        self.tableView.tableFooterView = footer
        self.clickHandler = clickListener
        self.tableView.registerNib(UINib(nibName: "TeacherViewCell", bundle: nil), forCellReuseIdentifier: StudentProgrammeCellId)
    }

    func setUpData(programmes: Array<StudentProgramme>) {
        self.programmes = programmes
        self.tableView.reloadData()
    }

    @objc  func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }


    @objc func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.programmes==nil ? 0:self.programmes.count
    }

    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: TeacherViewCell = tableView.dequeueReusableCellWithIdentifier(StudentProgrammeCellId, forIndexPath: indexPath) as! TeacherViewCell
        let myProgramme: StudentProgramme = self.programmes[indexPath.row]
        cell.teacherNameLabel.text = myProgramme.programme.description

        cell.teacherGoButton.addTarget(self, action: "clicked", forControlEvents: .TouchUpInside)
        cell.teacherGoButton.tag = indexPath.row
        return cell
    }


    func clicked(sender: UIButton) {
        let buttonTag = sender.tag
        let myProgramme: StudentProgramme = self.programmes[buttonTag as! Int]
        self.clickHandler?.doOnClick(myProgramme)
    }

}
