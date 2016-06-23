//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class DayWrapper:CellHandlingStrategy {


    let dayTime:String
    init(withDayTime:String){
        self.dayTime = withDayTime
    }

    func giveMeCellHandler() -> CellHandlerProtocol {
        return DayCellHandler(self)
    }


}
