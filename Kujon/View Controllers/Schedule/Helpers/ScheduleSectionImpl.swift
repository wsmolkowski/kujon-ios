//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ScheduleSectionImpl: ScheduleSection {

    let currentDate: String
    var listOfStrategys: Array<CellHandlingStrategy>
    init(withDate: String, listOfLecture: Array<CellHandlingStrategy>) {
        currentDate = withDate
        self.listOfStrategys = listOfLecture
    }


    func getSectionTitle() -> String {
        return currentDate
    }

    func getSectionSize() -> Int {
        return listOfStrategys.count
    }

    func getElementAtPosition(_ position: Int) -> CellHandlingStrategy {
        return listOfStrategys[position]
    }


    func getList() -> Array<CellHandlingStrategy> {
        return listOfStrategys
    }


    func addToList(_ list: Array<CellHandlingStrategy>) {
        listOfStrategys = listOfStrategys + list
    }


}
