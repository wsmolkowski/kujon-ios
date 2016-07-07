//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class ShareMenuItem : MenuItemWithController {


    func returnTitle() -> String {
        return StringHolder.shareApp
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return ShareViewController()}
    }

    func returnViewController() -> Bool {
        return true
    }


}
