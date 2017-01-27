//
// Created by Wojciech Maciejewski on 04/10/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class SearchMenuItem: MenuItemWithController {

    func returnTitle() -> String {
        return StringHolder.search
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "search-icon")
    }

    func returnViewControllerFunction() -> () -> UIViewController! {
        return {
            return SearchTableViewController()
        }
    }

    func returnViewController() -> Bool {
        return true
    }
}