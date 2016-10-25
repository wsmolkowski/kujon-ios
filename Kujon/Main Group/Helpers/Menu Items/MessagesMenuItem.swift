//
//  MessagesItem.swift
//  Kujon
//
//  Created by Adam on 25.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
class MessagesMenuItem: MenuItemWithController {

    func returnTitle() -> String {
        return StringHolder.messages
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "opinion-icon")
    }

    func returnViewControllerFunction() -> () -> UIViewController! {
        return {
            return MessagesTableViewController()
        }
    }

    func returnViewController() -> Bool {
        return true
    }

    
    
}

