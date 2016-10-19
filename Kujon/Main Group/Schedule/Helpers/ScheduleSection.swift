//
// Created by Wojciech Maciejewski on 21/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol ScheduleSection {
    func getSectionTitle() -> String

    func getSectionSize() -> Int

    func getElementAtPosition(_ position: Int) -> CellHandlingStrategy
    func getList() -> Array<CellHandlingStrategy>
    func addToList(_ list:Array<CellHandlingStrategy>)
}
