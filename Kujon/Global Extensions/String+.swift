//
//  String+.swift
//  Kujon
//
//  Created by Adam on 10.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension String {

    func attributedStringWithFont(font:UIFont, color:UIColor) -> NSAttributedString {
        let attributes: [String:AnyObject]? = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ]
        return NSAttributedString(string:self, attributes:attributes)
    }

    static func stripHTMLFromString(string: String) -> String {
        var copy = string
        while let range = copy.rangeOfString("<[^>]+>", options: .RegularExpressionSearch) {
            copy = copy.stringByReplacingCharactersInRange(range, withString: "")
        }
        copy = copy.stringByReplacingOccurrencesOfString("&nbsp;", withString: " ")
        copy = copy.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        copy = copy.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        return copy
    }

}