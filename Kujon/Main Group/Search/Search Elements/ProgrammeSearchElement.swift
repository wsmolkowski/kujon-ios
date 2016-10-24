//
// Created by Wojciech Maciejewski on 06/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ProgrammeSearchElement: SearchViewProtocol {

    private let myCellId = "asfafasfafasf"

    func provideSearchProtocol() -> SearchProviderProtocol {
        return ProgrammeSearchProvider()
    }
    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Kierunki", textInputPlaceholder: "Nazwa kierunku")
        return cell
    }

}
