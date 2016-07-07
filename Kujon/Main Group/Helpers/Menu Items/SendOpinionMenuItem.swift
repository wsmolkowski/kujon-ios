//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class SendOpinionMenuItem:MenuItemWithURL {

    func returnTitle() -> String {
        return "Prześlij Opinię"
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {}
    }

    func returnViewController() -> Bool {
        return false
    }

    func returnURL() -> NSURL! {
        return NSURL(string: "mailto:kujon@kujon.mobi&subject=Uwaga do Kujona")
    }


}
