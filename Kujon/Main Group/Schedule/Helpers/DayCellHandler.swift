//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol DayCellHandlerProtocol:CellHandlerProtocol{
    associatedtype T = DayTableViewCell
}

class DayCellHandler:DayCellHandlerProtocol {

    let dayWrapper:DayWrapper


    init(dayWrapper:DayWrapper){
        self.dayWrapper = dayWrapper
    }
    func handleCell(cell: DayTableViewCell) {
        cell.dayLabel.text  = dayWrapper.dayTime
    }


}
