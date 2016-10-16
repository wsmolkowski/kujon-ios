//
// Created by Wojciech Maciejewski on 07/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol MenuItemWithURL: MenuItemWithController {
    func returnURL() -> URL!
}
