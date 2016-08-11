//
// Created by Wojciech Maciejewski on 13/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static func kujonBlueColor ()->UIColor{ return UIColor(colorLiteralRed: 63.0/255,green: 186.0/255,blue: 217.0/255,alpha: 1.0)}
    static func kujonDarkerBlueColor ()->UIColor{ return UIColor(colorLiteralRed: 58.0/255,green: 168.0/255,blue: 198.0/255,alpha: 1.0)}
    static func kujonBlueColorWithAplha ()->UIColor{ return UIColor(colorLiteralRed: 63/255,green: 186/255,blue: 217/255,alpha: 0.5)}
    static func kujonDarkTextColor ()->UIColor{ return UIColor(colorLiteralRed: 42/255,green: 51/255,blue: 62/255,alpha: 0.5)}
    static func kujonCalendarBlue ()->UIColor{ return UIColor(colorLiteralRed: 217/255,green: 241/255,blue: 247/255,alpha: 1)}
    static func blackWithAlpha ()->UIColor{ return UIColor(colorLiteralRed: 0,green: 0,blue: 0,alpha: 0.34)}
    static func greyBackgroundColor ()->UIColor{ return UIColor(colorLiteralRed: 239/255,green: 242/255,blue: 248/255,alpha: 1)}
    static func lightGray ()->UIColor{ return UIColor(colorLiteralRed: 216/255,green: 216/255,blue: 216/255,alpha: 1)}
    static func calendarSeparatorColor ()->UIColor{ return UIColor(colorLiteralRed: 160/255,green: 160/255,blue: 160/255,alpha: 0.6)}
    static func kjnTealBlueColor() -> UIColor {
        return UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
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
}