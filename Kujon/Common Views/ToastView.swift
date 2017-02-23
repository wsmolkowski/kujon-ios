//
// Created by Wojciech Maciejewski on 01/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class ToastView: UIView {
    static let toastHeight:CGFloat = 50.0
    static let toastGap:CGFloat = 10;
    lazy var textLabel: UILabel = UILabel(frame: CGRect(x: 5.0, y: 5.0, width: self.frame.size.width - 10.0, height: self.frame.size.height - 10.0))
    static var completion: (() -> Void)?

    static func showInParent(_ parentView: UIView!, withText text: String, forDuration duration: double_t, completion: (() -> Void)? = nil) {

        guard let parentView = parentView else {
            return
        }

        //Count toast views are already showing on parent. Made to show several toasts one above another
        var toastsAlreadyInParent = 0;

        for view in parentView.subviews {
            if (view.isKind(of: ToastView.self)) {
                toastsAlreadyInParent += 1
            }
        }

        let parentFrame = parentView.frame;

        let yOrigin = parentFrame.size.height - getDouble(toastsAlreadyInParent)

        let selfFrame = CGRect(x: parentFrame.origin.x + 20.0, y: yOrigin, width: parentFrame.size.width - 40.0, height: toastHeight);
        let toast = ToastView(frame: selfFrame)

        toast.textLabel.backgroundColor = UIColor.clear
        toast.textLabel.textAlignment = NSTextAlignment.center
        toast.textLabel.textColor = UIColor.white
        toast.textLabel.numberOfLines = 2
        toast.textLabel.font = UIFont.systemFont(ofSize: 13.0)
        //        toast.textLabel.lineBreakMode = NSLineBreakMode.NSLineBreakByCharWrapping
        toast.addSubview(toast.textLabel)

        toast.backgroundColor = UIColor.darkGray
        toast.alpha = 0.0;
        toast.layer.cornerRadius = 4.0;
        toast.textLabel.text = text;

        parentView.addSubview(toast)
        UIView.animate(withDuration: 0.4, animations: {
            toast.alpha = 0.9
            toast.textLabel.alpha = 0.9
        })

        ToastView.completion = completion

        toast.perform(#selector(ToastView.hideSelf), with: nil, afterDelay: duration)

    }

    static private func getDouble(_ toastsAlreadyInParent : Int) -> CGFloat {
        return (70.0 + toastHeight * CGFloat(toastsAlreadyInParent) + toastGap * CGFloat(toastsAlreadyInParent));
    }

    func hideSelf() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.alpha = 0.0
            self?.textLabel.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
                ToastView.completion?()
        })
    }
    
}
