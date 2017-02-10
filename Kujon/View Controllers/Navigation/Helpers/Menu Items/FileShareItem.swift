//
//  FileShareItem.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

class FileShareItem: MenuItemWithController {

    func returnTitle() -> String {
        return StringHolder.fileShareMenuItem
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "share-icon")
    }

    func returnViewControllerFunction() -> () -> UIViewController! {
        return {
            return ActiveCoursesListTableViewController()
        }
    }

    func returnViewController() -> Bool {
        return true
    }


}
