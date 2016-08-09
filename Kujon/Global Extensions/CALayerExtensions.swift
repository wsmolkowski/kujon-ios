//
// Created by Wojciech Maciejewski on 09/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        var border = CALayer()

        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(CGRectGetMinX(self.frame), 0, CGRectGetWidth(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }

        border.backgroundColor = color.CGColor;

        self.addSublayer(border)
    }
}