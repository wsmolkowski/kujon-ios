//
// Created by Wojciech Maciejewski on 05/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FacultySearchElement: SearchViewProtocol {

    private let myCellId = "assafasfasfaf"

    func provideSearchProtocol() -> SearchProviderProtocol {
        return FacultySearchProvider()
    }
    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Wydziały", textInputPlaceholder: "Nazwa wydziału")
        return cell
    }

}