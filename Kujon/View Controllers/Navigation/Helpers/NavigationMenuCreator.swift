//
// Created by Wojciech Maciejewski on 10/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class NavigationMenuCreator {


    static func createNavMenuWithDrawerOpening(_ controller:UIViewController,selector:Selector,andTitle title:String = ""){
        let openDrawerButton =  UIBarButtonItem(image:UIImage(named: "menu-icon"),style: UIBarButtonItemStyle.plain,target: controller,
                action: selector)
        openDrawerButton.action = selector
        controller.navigationItem.leftBarButtonItem = openDrawerButton
        controller.navigationItem.title = title
    }

    static func createNavMenuWithBackButton(_ controller:UIViewController,selector:Selector,andTitle title:String = ""){
        let image = UIImage(named: "arrow-left-white")
        let button = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        button.setTitle(" " + StringHolder.back, for: UIControlState())
        let font = UIFont.kjnTextStyle2Font()
        button.titleLabel?.font = font
        button.addTarget(controller, action: selector, for: UIControlEvents.touchUpInside)
        button.sizeToFit()
        let closeButton =  UIBarButtonItem(customView: button)
        closeButton.action = selector
        controller.navigationItem.leftBarButtonItem = closeButton
        controller.navigationItem.title = title
    }
}
