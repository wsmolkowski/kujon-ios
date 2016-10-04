//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class CourseSearchElement : SearchViewProtocol {

    private let myCellId = "student_udeseaflaskfm"

    func provideSearchProtocol() -> SearchProviderProtocol {
        return CoursesSearchProvider()
    }
    func registerView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: myCellId)
    }


    func provideUITableViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SearchTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myCellId, forIndexPath: indexPath) as! SearchTableViewCell
        cell.textView.placeholder = "Znajdź przedmiot"
        return cell
    }

}
