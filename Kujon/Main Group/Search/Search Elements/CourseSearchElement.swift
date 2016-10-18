//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CourseSearchElement : SearchViewProtocol {

    fileprivate let myCellId = "student_udeseaflaskfm"

    func provideSearchProtocol() -> SearchProviderProtocol {
        return CoursesSearchProvider()
    }
    func registerView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! SearchTableViewCell
        cell.configureCellWithTitle("Przedmioty", textInputPlaceholder: "Nazwa przedmiotu")
        return cell
    }

}
