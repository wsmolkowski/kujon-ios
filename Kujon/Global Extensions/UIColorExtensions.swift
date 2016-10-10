//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static func kujonBlueColor(alpha alpha: CGFloat = 1.0)->UIColor{
        return UIColor(red: 63.0/255,green: 186.0/255,blue: 217.0/255,alpha:alpha)
    }
    static func kujonDarkerBlueColor ()->UIColor{ return UIColor(red: 58.0/255,green: 168.0/255,blue: 198.0/255,alpha: 1.0)}
    static func kujonBlueColorWithAplha ()->UIColor{ return UIColor(red: 63/255,green: 186/255,blue: 217/255,alpha: 0.5)}
    static func kujonDarkTextColor(alpha alpha: CGFloat = 0.5) -> UIColor {
        return UIColor(red: 42/255,green: 51/255,blue: 62/255,alpha: alpha)
    }
    static func blackWithAlpha(alpha alpha: CGFloat = 0.34) -> UIColor {
        return UIColor(red: 0,green: 0,blue: 0, alpha: alpha)
    }
    static func kujonCalendarBlue ()->UIColor{ return UIColor(red: 217/255,green: 241/255,blue: 247/255,alpha: 1)}
    static func greyBackgroundColor ()->UIColor{ return UIColor(colorLiteralRed: 239/255,green: 242/255,blue: 248/255,alpha: 1)}
    static func lightGray(alpha alpha: CGFloat = 1.0)->UIColor{ return UIColor(red: 216/255,green: 216/255,blue: 216/255,alpha: alpha)}
    static func calendarSeparatorColor ()->UIColor{ return UIColor(red: 160/255,green: 160/255,blue: 160/255,alpha: 0.6)}
    static func kjnTealBlueColor() -> UIColor {
        return UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
    }

    // helper mapping for communication with designer

    static func color3FBAD9(alpha alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.kujonBlueColor(alpha: alpha)
    }
    static func colorD8D8D8(alpha alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.lightGray(alpha: alpha)
    }
    static func color2A333E(alpha alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.kujonDarkTextColor(alpha: alpha)
    }
    static func color000000(alpha alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.kujonDarkTextColor(alpha: alpha)
    }




}

// Color palette


// Text styles

extension UIFont {
    class func kjnNavigationTitleFont() -> UIFont? {
        return UIFont(name: "Texta-Medium", size: 18.0)
    }

    class func kjnTextStyle4Font() -> UIFont? {
        return UIFont(name: "Lato-Semibold", size: 17.0)
    }

    class func kjnTextStyle3Font() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 17.0)
    }

    class func kjnTextStyle5Font() -> UIFont? {
        return UIFont(name: "Lato-Semibold", size: 15.0)
    }

    class func kjnTextStyle2Font() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 15.0)
    }

    class func kjnTextStyleFont() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 11.0)
    }

    class func kjnTextStyleFontSmall() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 9.0)
    }

    class func kjnFontLatoMedium(size size:CGFloat) -> UIFont? {
        return UIFont(name: "Lato-Medium", size: size)
    }

    class func kjnFontLatoRegular(size size:CGFloat) -> UIFont? {
        return UIFont(name: "Lato-Regular", size: size)
    }

    func bold() -> UIFont {
        let descriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
            return UIFont(descriptor: descriptor, size: 0)
        }

}