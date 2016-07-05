//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FacultieSection: SectionHelperProtocol {
    let facultieCellId="facCellIde"
    private var facId :FacId! = nil
    func fillUpWithData(courseDetails: CourseDetails) {
        facId = courseDetails.facId
    }

    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: facultieCellId)
    }

    func getSectionTitle() -> String {
        return "Jednostki"
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

    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(facultieCellId, forIndexPath: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = facId.name
        return cell
    }

    func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {
        let faculiteController = FacultieViewController(nibName: "FacultieViewController", bundle: NSBundle.mainBundle())
        faculiteController.facultieId = facId.id
        controller?.pushViewController(faculiteController, animated: true)
    }

}
