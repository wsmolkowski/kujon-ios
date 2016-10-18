//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CycleSection: SectionHelperProtocol {
    let cycleId = "cycleCellId"


    fileprivate var description: String! = nil
    fileprivate var terms: Array<Term> = Array()
    func fillUpWithData(_ courseDetails: CourseDetails) {
        if(courseDetails.term != nil) {


            if (courseDetails.term!.count > 0) {
                terms = courseDetails.term!

            }
        }
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: cycleId)
    }

    func getSectionTitle() -> String {
        return StringHolder.cycleLectures
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
    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: cycleId, for: position) as! GoFurtherViewCellTableViewCell
        cell.plainLabel.text = terms[(position as NSIndexPath).row].name
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?) {
        let term = terms[position]
        let popController = TermsPopUpViewController(nibName: "TermsPopUpViewController", bundle: Bundle.main)
        popController.modalPresentationStyle = .overCurrentContext
        controller?.present(popController, animated: false, completion: { popController.showAnimate(); })

        popController.showInView(term)
    }

}
