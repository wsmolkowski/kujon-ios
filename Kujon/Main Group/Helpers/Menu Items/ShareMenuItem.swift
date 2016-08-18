//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class ShareMenuItem : MenuItemWithURL {


    func returnTitle() -> String {
        return StringHolder.shareApp
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "share-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return nil}
    }

    func returnViewController() -> Bool {
        return true
    }

    func returnURL() -> NSURL! {
        return nil
    }


}
