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

    func attributedStringFromHTMLWithFont(completion: NSAttributedString? ->()) {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else {
            print("Unable to decode data from html string: \(self)")
            return completion(nil)
        }

        let options = [ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSNumber(unsignedInteger:NSUTF8StringEncoding),
        ]

        dispatch_async(dispatch_get_main_queue()) {
            if let attributedString = try? NSAttributedString(data:data, options:options, documentAttributes:nil) {
                completion(attributedString)
            } else {
                print("Unable to create attributed string from html string: \(self)")
                completion(nil)
            }
        }
    }


}