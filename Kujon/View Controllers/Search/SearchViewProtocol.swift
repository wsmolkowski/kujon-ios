//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol SearchViewProtocol {
    func registerView(_ tableView: UITableView)
    func provideSearchProtocol()->SearchProviderProtocol
    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell

}
