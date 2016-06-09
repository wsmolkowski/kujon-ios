//
// Created by Wojciech Maciejewski on 09/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

protocol MenuItemWithController {

    func returnTitle() -> String

    func returnImage() -> UIImage!

    func returnViewControllerFunction() -> () -> UIViewController!
}
