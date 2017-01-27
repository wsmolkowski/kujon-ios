//
//  ThesisDetailViewController.swift
//  Kujon
//
//  Created by Adam on 12.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisDetailTableViewController: UITableViewController {

    private enum SectionMap: Int {
        case header = 0
        case authors
        case supervisors
        case faculty

        static func sectionForIndex(_ index:Int) -> SectionMap {
            if let section = SectionMap(rawValue: index) {
                return section
            }
           fatalError("Invalid section index")
        }
    }

    private let itemCellId: String = "itemCellId"
    private let itemCellHeight: CGFloat = 50.0
    private let itemHeaderHeight: CGFloat = 50.0
    private let headerCellId: String = "headerCellId"
    private let headerCellHeight: CGFloat = 150.0
    private let sectionsCount: Int = 4

    var thesis: ThesisSearchInside?
    
    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.thesisDetailTitle
        configureTableView()
    }

    private func configureTableView() {
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
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .header ? headerCellHeight : itemCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .header ? headerCellForIndexPath(indexPath) : itemCellForIndexPath(indexPath)
    }

    private func headerCellForIndexPath(_ indexPath: IndexPath) -> ThesisDetailHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! ThesisDetailHeaderCell
        cell.thesisTitleLabel.text = thesis?.title
        cell.thesisTypeLabel.text = thesis?.type
        return cell
    }

    private func itemCellForIndexPath(_ indexPath: IndexPath) -> GoFurtherViewCellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let section = SectionMap.sectionForIndex(indexPath.section)
        let labelText: String?

        switch section {
        case .header: labelText = nil
        case .authors: labelText = thesis?.authors?[indexPath.row].getNameWithTitles()
        case .supervisors: labelText = thesis?.supervisors?[indexPath.row].getNameWithTitles()
        case .faculty: labelText = thesis?.faculty?.name
        }

        cell.plainLabel.text = labelText
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .authors:
            if let user = thesis?.authors?[indexPath.row] {
                presentStudentDetailControllerWithSimpleUser(user)
            }
        case .supervisors:
            if let user = thesis?.supervisors?[indexPath.row] {
                presentTeacherDetailControllerWithSimpleUser(user)
            }
        case .faculty:
            if let faculty = thesis?.faculty {
                 presentFacultyDetailControllerWithFaculty(faculty)
            }
        default: return
        }
    }

    private func presentStudentDetailControllerWithSimpleUser(_ user: SimpleUser) {
        let studentDetailController = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: nil)
        studentDetailController.user = user
        studentDetailController.userId = user.id
        navigationController?.pushViewController(studentDetailController, animated: true)
    }

    private func presentTeacherDetailControllerWithSimpleUser(_ user: SimpleUser) {
        let teacherDetailController = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: nil)
        teacherDetailController.simpleUser = user
        teacherDetailController.teacherId = user.id
        navigationController?.pushViewController(teacherDetailController, animated: true)
    }

    private func presentFacultyDetailControllerWithFaculty(_ faculty:FacultyShort) {
        let facultyDetailController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: nil)
        facultyDetailController.facultieId = faculty.id
        navigationController?.pushViewController(facultyDetailController, animated: true)
    }


}
