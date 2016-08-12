//
// Created by Wojciech Maciejewski on 12/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FloatingButtonDelegate {

    private let floatingSize: CGFloat = 55.0
    private let floatingMargin: CGFloat = 15.0
    private var floatingButton: UIButton! = nil

    func viewWillAppear(controller:UIViewController,selector:Selector) {
        floatingButton = UIButton(type: .Custom)
        let xPos = controller.view.frame.size.width - floatingSize - floatingMargin
        let yPos = controller.view.frame.origin.y + controller.view.frame.size.height - floatingSize - floatingMargin
        floatingButton?.frame = CGRectMake(xPos, yPos, floatingSize, floatingSize)
        floatingButton?.titleLabel?.numberOfLines = 2
        floatingButton?.titleLabel?.textAlignment = .Center
        floatingButton?.setTitle(NSDate().getDayMonth(), forState: .Normal)
        floatingButton?.addTarget(controller, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        floatingButton?.titleLabel?.font = UIFont.kjnTextStyleFont()
        floatingButton?.backgroundColor = UIColor.kujonBlueColor()
        floatingButton?.makeMyselfCircle()

        controller.navigationController?.view.addSubview(floatingButton!)

    }

     func viewWillDisappear() {
        floatingButton.removeFromSuperview()

    }

}
