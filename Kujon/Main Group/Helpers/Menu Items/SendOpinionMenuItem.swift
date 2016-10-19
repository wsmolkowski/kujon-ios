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

    func returnURL() -> URL! {
        let URLCharactersSet = NSCharacterSet.urlQueryAllowed
        return URL(string: "mailto:kujon@kujon.mobi?subject=Uwaga do Kujona".addingPercentEncoding(withAllowedCharacters: URLCharactersSet)!)
    }


}
