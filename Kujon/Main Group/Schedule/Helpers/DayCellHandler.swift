//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class DayCellHandler:CellHandlerProtocol {

    let dayWrapper:DayWrapper


    init(dayWrapper:DayWrapper){
        self.dayWrapper = dayWrapper
    }

    func handleCell(_ cell: inout UITableViewCell) {
        (cell as! DayTableViewCell).dayLabel.text = dayWrapper.dayTime
    }



}
