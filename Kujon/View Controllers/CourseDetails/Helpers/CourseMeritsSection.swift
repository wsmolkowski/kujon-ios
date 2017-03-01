//
//  CourseMeritsSection.swift
//  Kujon
//
//  Created by Adam on 24.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CourseMeritsSection: SectionHelperProtocol {

    private var description:String?
    private var bibliography:String?
    private var assessmentCiteria:String?

    let descriptionCellId = "courseMeritsCellId"


    func fillUpWithData(_ courseDetails: CourseDetails) {
        description = courseDetails.description
        bibliography = courseDetails.bibliography
        assessmentCiteria = courseDetails.assessmentCriteria
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "CourseMeritsTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: position) as! CourseMeritsTableViewCell
        if let description = description, let bibliography = bibliography, let assessmentCiteria = assessmentCiteria {
            cell.configureCellWith(description: description, bibliography: bibliography, assessmentCriteria: assessmentCiteria)
        }
        cell.layoutIfNeeded()
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?, setDelegate delegate: AnyObject?) {
        // do nothing
    }
}
