//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

import UIKit

class LectureCellHandler: CellHandlerProtocol {

    let wrapper: LectureWrapper

    init(lectureWrapper: LectureWrapper) {
        self.wrapper = lectureWrapper
    }

    func handleCell(inout cell: UITableViewCell) {

        (cell as! LectureTableViewCell).timeLabel.text = wrapper.startTime + " \n" + wrapper.endTime + " \n" + "s. " + wrapper.lecture.roomNumber
        let lecturer = wrapper.lecture.lecturers[0] as SimpleUser!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if (lecturer != nil) {
            (cell as! LectureTableViewCell).topic.text = wrapper.lecture.name
        } else {

            (cell as! LectureTableViewCell).topic.text = wrapper.lecture.name + " \n" + lecturer.firstName + " " + lecturer.lastName
        }
    }


}
