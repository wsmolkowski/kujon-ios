//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CycleSection: SectionHelperProtocol {
    let cycleId = "cycleCellId"


    private var description: String! = nil
    private var terms: Array<Term> = Array()
    func fillUpWithData(courseDetails: CourseDetails) {
            if(courseDetails.term.count > 0){
                terms = courseDetails.term

            }
    }

    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: cycleId)
    }

    func getSectionTitle() -> String {
        return "Zajęcia w cyklu"
    }

    func getSectionSize() -> Int {
        return terms.count
    }
    func getRowHeight() -> Int {
        return StandartSection.rowHeight
    }


    func getSectionHeaderHeight() -> CGFloat {
        return StandartSection.sectionHeight
    }
    func giveMeCellAtPosition(tableView: UITableView, onPosition position: NSIndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(cycleId, forIndexPath: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = terms[position.row].name
        return cell
    }

    func reactOnSectionClick(position: Int, withController controller: UINavigationController?) {
        let term = terms[position]
        //TODO popUp with cycle
    }

}