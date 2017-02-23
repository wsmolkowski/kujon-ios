//
// Created by Wojciech Maciejewski on 12/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class FloatingButtonDelegate {

    private let floatingSize: CGFloat = 55.0
    private let floatingMargin: CGFloat = 15.0
    private var floatingButton: UIButton?

    func viewWillAppear(_ controller:UIViewController,selector:Selector) {
        floatingButton = UIButton(type: .custom)
        let xPos = controller.view.frame.size.width - floatingSize - floatingMargin
        let yPos = controller.view.frame.origin.y + controller.view.frame.size.height - floatingSize - floatingMargin
        floatingButton?.frame = CGRect(x: xPos, y: yPos, width: floatingSize, height: floatingSize)
        floatingButton?.titleLabel?.numberOfLines = 2
        floatingButton?.titleLabel?.textAlignment = .center
        floatingButton?.setTitle(Date().getDayMonth(), for: UIControlState())
        floatingButton?.addTarget(controller, action: selector, for: UIControlEvents.touchUpInside)
        floatingButton?.titleLabel?.font = UIFont.kjnTextStyleFont()
        floatingButton?.backgroundColor = UIColor.kujonBlueColor()
        floatingButton?.makeMyselfCircle()

        controller.navigationController?.view.addSubview(floatingButton!)

    }

     func viewWillDisappear() {
        floatingButton?.removeFromSuperview()

    }

}
