//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class BibliographySection: SectionHelperProtocol {
    let bibliographyCellId = "biblCellId"


    fileprivate var description: String! = nil
    func fillUpWithData(_ courseDetails: CourseDetails) {
        description = courseDetails.bibliography
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: bibliographyCellId)
    }

    func getSectionTitle() -> String {
        return StringHolder.bibliography
    }

    func getSectionSize() -> Int {
        return 1
    }

    func getRowHeight() -> Int {
        return StandartSection.rowHeight
    }


    func getSectionHeaderHeight() -> CGFloat {
        return StandartSection.sectionHeight
    }

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: bibliographyCellId, for: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = description
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?) {
        let textController = TextViewController(nibName: "TextViewController", bundle: Bundle.main)
        textController.text = description
        textController.myTitle = getSectionTitle()
        controller?.pushViewController(textController, animated: true)
    }
}
