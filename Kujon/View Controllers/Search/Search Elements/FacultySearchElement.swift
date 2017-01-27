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
    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle(StringHolder.faculties, textInputPlaceholder: StringHolder.facultyName)
        return cell
    }

}
