//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class DayWrapper:CellHandlingStrategy {


    let dayTime:String
    var myCellHandler :DayCellHandler! = nil

    init(withDayTime:String){
        self.dayTime = withDayTime
    }

    func giveMyStrategy() -> CellHandlerProtocol {
        if(self.myCellHandler==nil){
            self.myCellHandler = DayCellHandler(dayWrapper: self)
        }
        return self.myCellHandler
    }


    func giveMeMyCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return  tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewController.DayCellId, for: indexPath)
    }

    func amILectureWrapper() -> Bool {
        return false
    }

    func handleClick(_ controller: UINavigationController?) {
    }


}
