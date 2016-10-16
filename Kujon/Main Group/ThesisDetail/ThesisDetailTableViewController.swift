//
//  ThesisDetailViewController.swift
//  Kujon
//
//  Created by Adam on 12.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisDetailTableViewController: UITableViewController {

    fileprivate enum SectionMap: Int {
        case header = 0
        case authors
        case supervisors
        case faculty

        static func sectionForIndex(_ index:Int) -> SectionMap {
            switch index {
            case header.rawValue: return header
            case authors.rawValue: return authors
            case supervisors.rawValue: return supervisors
            case faculty.rawValue: return faculty
            default: fatalError("Invalid section index")
            }
        }
    }

    fileprivate let itemCellId: String = "itemCellId"
    fileprivate let itemCellHeight: CGFloat = 50.0
    fileprivate let itemHeaderHeight: CGFloat = 50.0
    fileprivate let headerCellId: String = "headerCellId"
    fileprivate let headerCellHeight: CGFloat = 200.0
    fileprivate let sectionsCount: Int = 4

    var thesis: ThesisSearchInside?
    
    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.thesisDetailTitle
        configureTableView()
    }

    fileprivate func configureTableView() {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        tableView.register(UINib(nibName: "ThesisDetailHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .greyBackgroundColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .header: return 1
        case .authors: return thesis?.authors?.count ?? 0
        case .supervisors: return thesis?.supervisors?.count ?? 0
        case .faculty: return 1
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)

        switch (section) {
        case .header: return nil
        case .authors: return createLabelForSectionTitle(StringHolder.authors)
        case .supervisors: return createLabelForSectionTitle(StringHolder.supervisors)
        case .faculty: return createLabelForSectionTitle(StringHolder.faculty)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = SectionMap.sectionForIndex(section)
        return section == .header ? 0.0 : itemHeaderHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = SectionMap.sectionForIndex((indexPath as NSIndexPath).section)
        return section == .header ? headerCellHeight : itemCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex((indexPath as NSIndexPath).section)
        return section == .header ? headerCellForIndexPath(indexPath) : itemCellForIndexPath(indexPath)
    }

    fileprivate func headerCellForIndexPath(_ indexPath: IndexPath) -> ThesisDetailHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! ThesisDetailHeaderCell
        cell.thesisTitleLabel.text = thesis?.title
        cell.thesisTypeLabel.text = thesis?.type
        return cell
    }

    fileprivate func itemCellForIndexPath(_ indexPath: IndexPath) -> GoFurtherViewCellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let section = SectionMap.sectionForIndex((indexPath as NSIndexPath).section)
        let labelText: String?

        switch section {
        case .header: labelText = nil
        case .authors: labelText = thesis?.authors?[(indexPath as NSIndexPath).row].getNameWithTitles()
        case .supervisors: labelText = thesis?.supervisors?[(indexPath as NSIndexPath).row].getNameWithTitles()
        case .faculty: labelText = thesis?.faculty?.name
        }

        cell.plainLabel.text = labelText
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SectionMap.sectionForIndex((indexPath as NSIndexPath).section)
        switch section {
        case .authors:
            if let user = thesis?.authors?[(indexPath as NSIndexPath).row] {
                presentStudentDetailControllerWithSimpleUser(user)
            }
        case .supervisors:
            if let user = thesis?.supervisors?[(indexPath as NSIndexPath).row] {
                presentTeacherDetailControllerWithSimpleUser(user)
            }
        case .faculty:
            if let faculty = thesis?.faculty {
                 presentFacultyDetailControllerWithFaculty(faculty)
            }
        default: return
        }
    }

    fileprivate func presentStudentDetailControllerWithSimpleUser(_ user: SimpleUser) {
        let studentDetailController = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: nil)
        studentDetailController.user = user
        studentDetailController.userId = user.id
        navigationController?.pushViewController(studentDetailController, animated: true)
    }

    fileprivate func presentTeacherDetailControllerWithSimpleUser(_ user: SimpleUser) {
        let teacherDetailController = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: nil)
        teacherDetailController.simpleUser = user
        teacherDetailController.teacherId = user.id
        navigationController?.pushViewController(teacherDetailController, animated: true)
    }

    fileprivate func presentFacultyDetailControllerWithFaculty(_ faculty:FacultyShort) {
        let facultyDetailController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: nil)
        facultyDetailController.facultieId = faculty.id
        navigationController?.pushViewController(facultyDetailController, animated: true)
    }


}
