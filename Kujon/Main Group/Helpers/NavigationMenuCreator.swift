//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class NavigationMenuCreator {


    static func createNavMenuWithDrawerOpening(controller:UIViewController,selector:Selector){
        let openDrawerButton =  UIBarButtonItem(title:"open drawer",style: UIBarButtonItemStyle.Plain,target: controller,
                action: selector)
        openDrawerButton.action = selector
        controller.navigationItem.leftBarButtonItem = openDrawerButton
    }
}
