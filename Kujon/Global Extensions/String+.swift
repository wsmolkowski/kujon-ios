//
//  String+.swift
//  Kujon
//
//  Created by Adam on 10.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension String {

    func toAttributedStringWithFont(_ font:UIFont, color:UIColor) -> NSAttributedString {
        let attributes: [String:AnyObject]? = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ]
        return NSAttributedString(string:self, attributes:attributes)
    }

    static func stripHTMLFromString(_ string: String) -> String {
        var copy = string
        while let range = copy.range(of: "<[^>]+>", options: .regularExpression) {
            copy = copy.replacingCharacters(in: range, with: "")
        }
        copy = copy.replacingOccurrences(of: "&nbsp;", with: " ")
        copy = copy.replacingOccurrences(of: "&amp;", with: "&")
        copy = copy.replacingOccurrences(of: "&quot;", with: "\"")
        return copy
    }

}
