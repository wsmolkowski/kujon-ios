//
// Created by Wojciech Maciejewski on 23/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol CellHandlerProtocol {
    associatedtype T:UITableViewCell


    func handleCell(cell:T);
}
