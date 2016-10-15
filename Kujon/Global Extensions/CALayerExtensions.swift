//
// Created by Wojciech Maciejewski on 09/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

extension CALayer {

    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: self.frame.minX, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: self.frame.minX, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }
}

extension UIView {
    func addTopBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.height,
                multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.top,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1, constant: 0))
    }

    func addBottomBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.height,
                multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1, constant: 0))
    }
    func addLeftBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.width,
                multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.top,
                multiplier: 1, constant: 0))
    }
    func addRightBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.width,
                multiplier: 1, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self,
                attribute: NSLayoutAttribute.top,
                multiplier: 1, constant: 0))
    }

}
