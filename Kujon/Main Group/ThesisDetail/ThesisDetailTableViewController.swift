//
//  ThesisDetailViewController.swift
//  Kujon
//
//  Created by Adam on 12.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisDetailTableViewController: UITableViewController {

    enum SectionMap: Int {
        case Header = 0
        case Authors
        case Supervisors
        case Faculty

        static func sectionForIndex(index:Int) -> SectionMap {
            switch index {
            case Header.rawValue: return Header
            case Authors.rawValue: return Authors
            case Supervisors.rawValue: return Supervisors
            case Faculty.rawValue: return Faculty
            default: fatalError("Invalid section index")
            }
        }
    }

    let itemCellId: String = "itemCellId"
    let itemCellHeight: CGFloat = 50.0
    let itemHeaderHeight: CGFloat = 50.0
    let headerCellId: String = "headerCellId"
    let headerCellHeight: CGFloat = 200.0
    let sectionsCount: Int = 4

    var thesis: ThesisSearchInside?
    
    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.thesisDetailTitle
        configureTableView()
    }

    private func configureTableView() {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        tableView.registerNib(UINib(nibName: "ThesisDetailHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        tableView.separatorStyle = .None
        tableView.backgroundColor = .greyBackgroundColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .Header: return 1
        case .Authors: return thesis?.authors?.count ?? 0
        case .Supervisors: return thesis?.supervisors?.count ?? 0
        case .Faculty: return 1
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)

        switch (section) {
        case .Header: return nil
        case .Authors: return createLabelForSectionTitle(StringHolder.authors)
        case .Supervisors: return createLabelForSectionTitle(StringHolder.supervisors)
        case .Faculty: return createLabelForSectionTitle(StringHolder.faculty)
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = SectionMap.sectionForIndex(section)
        return section == .Header ? 0.0 : itemHeaderHeight
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .Header ? headerCellHeight : itemCellHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .Header ? headerCellForIndexPath(indexPath) : itemCellForIndexPath(indexPath)
    }

    private func headerCellForIndexPath(indexPath: NSIndexPath) -> ThesisDetailHeaderCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(headerCellId, forIndexPath: indexPath) as! ThesisDetailHeaderCell
        cell.thesisTitleLabel.text = thesis?.title
        cell.thesisTypeLabel.text = thesis?.type
        return cell
    }

    private func itemCellForIndexPath(indexPath: NSIndexPath) -> GoFurtherViewCellTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let section = SectionMap.sectionForIndex(indexPath.section)
        let labelText: String?

        switch section {
        case .Header: labelText = nil
        case .Authors: labelText = thesis?.authors?[indexPath.row].getNameWithTitles()
        case .Supervisors:
            labelText = thesis?.supervisors?[indexPath.row].getNameWithTitles()
        case .Faculty: labelText = thesis?.faculty?.name
        }

        cell.plainLabel.text = labelText
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .Authors:
            if let user = thesis?.authors?[indexPath.row] {
                presentStudentDetailControllerWithSimpleUser(user)
            }
        case .Supervisors:
            if let user = thesis?.supervisors?[indexPath.row] {
                presentTeacherDetailControllerWithSimpleUser(user)
            }
        case .Faculty:
            if let faculty = thesis?.faculty {
                 presentFacultyDetailControllerWithFaculty(faculty)
            }

        default: return
        }
    }

    private func presentStudentDetailControllerWithSimpleUser(user: SimpleUser) {
        let studentDetailController = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: nil)
        studentDetailController.user = user
        studentDetailController.userId = user.id
        navigationController?.pushViewController(studentDetailController, animated: true)
    }

    private func presentTeacherDetailControllerWithSimpleUser(user: SimpleUser) {
        let teacherDetailController = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: nil)
        teacherDetailController.simpleUser = user
        teacherDetailController.teacherId = user.id
        navigationController?.pushViewController(teacherDetailController, animated: true)
    }

    private func presentFacultyDetailControllerWithFaculty(faculty:FacultyShort) {
        let facultyDetailController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: nil)
        facultyDetailController.facultieId = faculty.id
        navigationController?.pushViewController(facultyDetailController, animated: true)
    }


}
