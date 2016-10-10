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
    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Prace dyplomowe", textInputPlaceholder: "Tytuł pracy")
        return cell
    }

}
