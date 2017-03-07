//
//  CourseMeritsAssessemntSection.swift
//  Kujon
//
//  Created by Adam on 06.03.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class CourseMeritsAssessemntSection: SectionHelperProtocol {

    private var assessmentCriteria: String?
    let assessmentCellId = "assessmentCriteriaCourseMeritsCellId"


    func fillUpWithData(_ courseDetails: CourseDetails) {
        assessmentCriteria = courseDetails.assessmentCriteria
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "CourseMeritsTableViewCell", bundle: nil), forCellReuseIdentifier: assessmentCellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: assessmentCellId, for: position) as! CourseMeritsTableViewCell
        if let assessmentCriteria = assessmentCriteria {
            cell.configureCellWith(title: StringHolder.assessmentCriteriaTitle, content: assessmentCriteria)
        }
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?, setDelegate delegate: AnyObject?) {
        // do nothing
    }
}
