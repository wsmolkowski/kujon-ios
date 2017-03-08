//
//  CourseMeritsBibliographySection.swift
//  Kujon
//
//  Created by Adam on 06.03.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class CourseMeritsBibliographySection: SectionHelperProtocol {

    private var bibliography:String?
    let bibliographyCellId = "bibliographyCourseMeritsCellId"
    private var isFolded: Bool = true


    func fillUpWithData(_ courseDetails: CourseDetails) {
        bibliography = courseDetails.bibliography
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "CourseMeritsTableViewCell", bundle: nil), forCellReuseIdentifier: bibliographyCellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: bibliographyCellId, for: position) as! CourseMeritsTableViewCell
        if let bibliography = bibliography {
            cell.configureCellWith(title: StringHolder.bibliographyTitle,content: bibliography, isFolded: isFolded, tag: 1004)
        }
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?, setDelegate delegate: AnyObject?) {
        // do nothing
    }

    func updateState(isFolded: Bool) {
        self.isFolded = isFolded
    }
}
