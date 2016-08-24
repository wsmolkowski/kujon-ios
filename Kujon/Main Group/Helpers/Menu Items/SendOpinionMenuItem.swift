//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
class SendOpinionMenuItem:MenuItemWithURL {

    func returnTitle() -> String {
        return StringHolder.sendOpinion
    }

    func returnImage() -> UIImage! {
        return UIImage(named: "opinion-icon")
    }

    func returnViewControllerFunction()->() -> UIViewController! {
        return {return nil}
    }

    func returnViewController() -> Bool {
        return false
    }

    func returnURL() -> NSURL! {
        return NSURL(string: "mailto:kujon@kujon.mobi?subject=Uwaga do Kujona".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
    }


}
