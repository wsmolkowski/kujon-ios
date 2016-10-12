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

    func attributedStringFromHTML(completion: NSAttributedString? ->()) {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else {
            print("Unable to decode data from html string")
            return completion(nil)
        }

        let options = [ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSNumber(unsignedInteger:NSUTF8StringEncoding)
        ]

        dispatch_async(dispatch_get_main_queue()) {
            if let attributedString = try? NSAttributedString(data:data, options:options, documentAttributes:nil) {
                completion(attributedString)
            } else {
                print("Unable to create attributed string from html string")
                completion(nil)
            }
        }
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