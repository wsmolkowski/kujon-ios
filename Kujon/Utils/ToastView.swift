//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class ToastView: UIView {
    static let toastHeight:CGFloat = 50.0
    static let toastGap:CGFloat = 10;
    lazy var textLabel: UILabel = UILabel(frame: CGRectMake(5.0, 5.0, self.frame.size.width - 10.0, self.frame.size.height - 10.0))


    static func showInParent(parentView: UIView!, withText text: String, forDuration duration: double_t) {

        //Count toast views are already showing on parent. Made to show several toasts one above another
        var toastsAlreadyInParent = 0;

        for view in parentView.subviews {
            if (view.isKindOfClass(ToastView)) {
                toastsAlreadyInParent += 1
            }
        }

        let parentFrame = parentView.frame;

        let yOrigin = parentFrame.size.height - getDouble(toastsAlreadyInParent)

        let selfFrame = CGRectMake(parentFrame.origin.x + 20.0, yOrigin, parentFrame.size.width - 40.0, toastHeight);
        let toast = ToastView(frame: selfFrame)

        toast.textLabel.backgroundColor = UIColor.clearColor()
        toast.textLabel.textAlignment = NSTextAlignment.Center
        toast.textLabel.textColor = UIColor.whiteColor()
        toast.textLabel.numberOfLines = 2
        toast.textLabel.font = UIFont.systemFontOfSize(13.0)
//        toast.textLabel.lineBreakMode = NSLineBreakMode.NSLineBreakByCharWrapping
        toast.addSubview(toast.textLabel)

        toast.backgroundColor = UIColor.darkGrayColor()
        toast.alpha = 0.0;
        toast.layer.cornerRadius = 4.0;
        toast.textLabel.text = text;

        parentView.addSubview(toast)
        UIView.animateWithDuration(0.4, animations: {
            toast.alpha = 0.9
            toast.textLabel.alpha = 0.9
        })


        toast.performSelector(Selector("hideSelf"), withObject: nil, afterDelay: duration)

    }

    static private func getDouble(toastsAlreadyInParent : Int) -> CGFloat {
        return (70.0 + toastHeight * CGFloat(toastsAlreadyInParent) + toastGap * CGFloat(toastsAlreadyInParent));
    }

     func hideSelf() {
        UIView.animateWithDuration(0.4, animations: {
            self.alpha = 0.0
            self.textLabel.alpha = 0.0
        }, completion: { t in self.removeFromSuperview() })
    }

}
