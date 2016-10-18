//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class DescriptionSection: SectionHelperProtocol {
    let descriptionCellId="descCellId"


    private var description:String! = nil
    func fillUpWithData(_ courseDetails: CourseDetails) {
        description  = courseDetails.description
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellId)
    }

    func getSectionTitle() -> String {
        return StringHolder.description
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
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: position) as! GoFurtherViewCellTableViewCell
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
