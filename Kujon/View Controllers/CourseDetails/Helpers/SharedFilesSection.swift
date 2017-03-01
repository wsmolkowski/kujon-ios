//
//  SharedFilesSection.swift
//  Kujon
//
//  Created by Adam on 10.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

class  SharedFilesSection: SectionHelperProtocol {

    private let cellId = "sharedFilesCellId"
    private var courseId: String?
    private var termId: String?
    private var courseName: String?
    private var filesCount: Int?

    func fillUpWithData(_ courseDetails: CourseDetails) {
        courseId = courseDetails.courseId
        termId = courseDetails.termId
        courseName = courseDetails.courseName
        filesCount = courseDetails.filesCount
    }

    internal func updateFilesCount(_ count: Int) {
        self.filesCount = count
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "ActiveCourseCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    func getSectionTitle() -> String? {
        return nil
    }

    func getSectionSize() -> Int {
        return 1
    }

    func sectionHeaderHeight() -> CGFloat {
        return 0
    }

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: position) as! ActiveCourseCell
        let count = filesCount == nil ? 0 : filesCount!
        cell.configure(courseName: StringHolder.fileShareTitle, filesNumber: count, showFolderIcon: true)
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?, setDelegate delegate: AnyObject? = nil) {
        guard let courseId = courseId, let termId = termId, let courseName = courseName else {
            return
        }
        let storyboard = UIStoryboard.init(name: "SharedFilesViewController", bundle: nil)
        let sharedFilesController = storyboard.instantiateViewController(withIdentifier: "SharedFilesViewController") as! SharedFilesViewController
        sharedFilesController.courseId = courseId
        sharedFilesController.termId = termId
        sharedFilesController.courseName = courseName
        if let delegate = delegate as? SharedFilesViewControllerDelegate {
            sharedFilesController.delegate = delegate
        }
        controller?.pushViewController(sharedFilesController, animated: true)
    }
    
}
