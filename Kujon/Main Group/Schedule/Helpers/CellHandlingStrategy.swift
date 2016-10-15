//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CellHandlingStrategy {
    func giveMyStrategy() -> CellHandlerProtocol

    func amILectureWrapper() -> Bool

    func giveMeMyCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell

    func handleClick(_ controller:UINavigationController?)
}
