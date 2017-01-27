//
// Created by Wojciech Maciejewski on 09/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

protocol NavigationDelegate {
    func setNavigationProtocol(_ delegate:NavigationMenuProtocol)
    func isSecond()->Bool
}

extension NavigationDelegate{
    func isSecond() -> Bool {
        return false
    }

}
