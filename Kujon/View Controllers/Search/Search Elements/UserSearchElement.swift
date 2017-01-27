//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class UserSearchElement : SearchViewProtocol {

    private let myCellId = "afsasfafasf"


    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }

    func provideSearchProtocol() -> SearchProviderProtocol {
        return UserSearchProvider()
    }


    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Studenci i pracownicy", textInputPlaceholder: "Imię i nazwisko")
        return cell
    }

}
