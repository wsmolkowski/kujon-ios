//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserSearchElement : SearchViewProtocol {

    private let myCellId = "afsasfafasf"


    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }

    func provideSearchProtocol() -> SearchProviderProtocol {
        return UserSearchProvider()
    }


    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Studenci i pracownicy", textInputPlaceholder: "Imię i nazwisko")
        return cell
    }

}
