//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol SearchViewProtocol {
    func registerView(tableView: UITableView)
    func provideSearchProtocol()->SearchProviderProtocol
    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell

}
