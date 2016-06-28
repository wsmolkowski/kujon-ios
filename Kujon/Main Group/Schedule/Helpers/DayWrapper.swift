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


    func giveMeMyCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return  tableView.dequeueReusableCellWithIdentifier(ScheduleTableViewController.DayCellId, forIndexPath: indexPath)
    }

    func amILectureWrapper() -> Bool {
        return false
    }

    func handleClick(controller: UINavigationController?) {
    }


}
