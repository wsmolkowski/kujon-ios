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
    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchTableViewCell
        cell.textView.placeholder = "Znajdź kierunek"
        return cell
    }

}