//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ScheduleSectionImpl: ScheduleSection {

    let currentDate: String
    let listOfLectures: Array<LectureWrapper>
    init(withDate: String, listOfLecture: Array<LectureWrapper>) {
        currentDate = withDate
        self.listOfLectures = listOfLecture
    }


    func getSectionTitle() -> String {
        return currentDate
    }

    func getSectionSize() -> Int {
        return listOfLectures.count
    }

    func getElementAtPosition(position: Int) -> LectureWrapper {
        return listOfLectures[position]
    }

}
