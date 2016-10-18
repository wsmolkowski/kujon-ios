//
// Created by Wojciech Maciejewski on 09/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class ThesisSearchElement: SearchViewProtocol {


    private let myCellId = "safasf01jswfn29fun"

    func provideSearchProtocol() -> SearchProviderProtocol {
        return ThesisSearchProvider()
    }
    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Prace dyplomowe", textInputPlaceholder: "Tytuł pracy")
        return cell
    }

}
