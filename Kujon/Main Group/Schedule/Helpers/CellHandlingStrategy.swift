//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CellHandlingStrategy {
    func giveMyStrategy() -> CellHandlerProtocol

    func amILectureWrapper() -> Bool

    func giveMeMyCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell

    func handleClick(controller:UIViewController?)
}
