//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class NavigationMenuCreator {


    static func createNavMenuWithDrawerOpening(controller:UIViewController,selector:Selector,andTitle title:String = ""){
        let openDrawerButton =  UIBarButtonItem(image:UIImage(named: "menu-icon"),style: UIBarButtonItemStyle.Plain,target: controller,
                action: selector)
        openDrawerButton.action = selector
        controller.navigationItem.leftBarButtonItem = openDrawerButton
        controller.navigationItem.title = title
    }

    static func createNavMenuWithBackButton(controller:UIViewController,selector:Selector,andTitle title:String = ""){
        let closeButton =  UIBarButtonItem(image:UIImage(named: "arrow-left"),style: UIBarButtonItemStyle.Plain,target: controller,
                action: selector)
        closeButton.action = selector
        controller.navigationItem.leftBarButtonItem = closeButton
        controller.navigationItem.title = title
    }
}
