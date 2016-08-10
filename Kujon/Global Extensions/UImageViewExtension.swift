//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    func makeMyselfCircle(){
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }

    func makeMyselfCircleWithBorder(){
        self.makeMyselfCircle()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1

    }
}
