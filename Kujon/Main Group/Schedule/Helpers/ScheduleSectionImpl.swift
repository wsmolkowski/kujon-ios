//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ScheduleSectionImpl:ScheduleSection {

    let currentDate :NSDate
    let listOfLectures :Array<Lecture>
    init(withDate:NSDate, listOfLecture:Array<Lecture>){
        currentDate = withDate
        self.listOfLectures = listOfLecture
    }


    func getSectionTitle() -> String {
        return currentDate.dateToString()
    }

    func getSectionSize() -> Int {
        return listOfLectures.count
    }

    func getElementAtPosition(position: Int) -> Lecture {
        return listOfLectures[position]
    }

}
