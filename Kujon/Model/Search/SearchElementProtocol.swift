//
// Created by Wojciech Maciejewski on 30/09/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

public protocol SearchElementProtocol {
    func getTitle()->String
    func reactOnClick(mainController: UINavigationController)
}
