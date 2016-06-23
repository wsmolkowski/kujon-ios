//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
protocol LectureCellHandlerProtocol:CellHandlerProtocol{
    associatedtype T = LectureTableViewCell
}
class LectureCellHandler:LectureCellHandlerProtocol {

    let wrapper :LectureWrapper

    init(lectureWrapper:LectureWrapper){
        self.wrapper = lectureWrapper
    }
    func handleCell(cell: LectureTableViewCell) {
        cell.timeLabel.text = wrapper.startTime + " \n" + wrapper.endTime + " \n" + "s. " + wrapper.lecture.roomNumber
        let lecturer = wrapper.lecture.lecturers[0] as SimpleUser
        cell.topic.text = wrapper.lecture.name + " \n" + lecturer.firstName + " " + lecturer.lastName

    }

}
