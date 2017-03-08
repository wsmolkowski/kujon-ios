//
//  CourseMeritsDescriptionSection
//  Kujon
//
//  Created by Adam on 24.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CourseMeritsDescriptionSection: SectionHelperProtocol {

    private var description:String?
    let descriptionCellId = "courseMeritsCellId"
    private var isFolded: Bool = true

    func fillUpWithData(_ courseDetails: CourseDetails) {
        description = courseDetails.description
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
        if let description = description {
            cell.configureCellWith(title: StringHolder.descriptionTitle, content: description, isFolded: isFolded, showUpperSeparator: true, tag: 1003)
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
