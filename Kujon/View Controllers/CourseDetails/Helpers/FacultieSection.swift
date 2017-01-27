//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FacultieSection: SectionHelperProtocol {
    let facultieCellId="facCellIde"
    private var facId :FacId! = nil
    func fillUpWithData(_ courseDetails: CourseDetails) {
        facId = courseDetails.facId
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: facultieCellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: facultieCellId, for: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = facId.name
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?) {
        let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
        faculiteController.facultieId = facId.id
        controller?.pushViewController(faculiteController, animated: true)
    }

}
