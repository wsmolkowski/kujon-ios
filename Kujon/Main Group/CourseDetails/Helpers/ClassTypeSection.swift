//
// Created by Wojciech Maciejewski on 05/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ClassTypeSection:SectionHelperProtocol {

    let classTypeCellId = "classTypeCellId"


    private var typesAsString: String?

    func fillUpWithData(_ courseDetails: CourseDetails) {
        var types: [String] = []
        if let groups = courseDetails.groups {
            for courseGroup in groups {
                types.append(courseGroup.classType)
            }
        }
        if types.count > 0 {
            typesAsString = types.joined(separator: ",")
        }
    }

    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: classTypeCellId)
    }

    func getSectionTitle() -> String? {
        return StringHolder.classType
    }

    func getSectionSize() -> Int {
        return typesAsString == nil ? 0 : 1
    }

    func sectionHeaderHeight() -> CGFloat {
        return 48
    }

    func giveMeCellAtPosition(_ tableView: UITableView, onPosition position: IndexPath) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: classTypeCellId, for: position) as! GoFurtherViewCellTableViewCell
        if let typesAsString = typesAsString {
            cell.plainLabel.text = typesAsString
        }
        cell.arrow.isHidden = true
        return cell
    }

    func reactOnSectionClick(_ position: Int, withController controller: UINavigationController?) {
//        let textController = TextViewController(nibName: "TextViewController", bundle: NSBundle.mainBundle())
//        textController.text = description
//        textController.myTitle = getSectionTitle()
//        controller?.pushViewController(textController, animated: true)
    }

}
