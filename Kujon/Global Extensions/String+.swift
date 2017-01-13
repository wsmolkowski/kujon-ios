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

extension String {

    enum RegExPattern: String {
        case url = "(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))"
    }

    func findAllMatches(pattern: RegExPattern) -> [String] {
        var matches = [String]()
        do {
            let regex = try NSRegularExpression(pattern: pattern.rawValue, options: NSRegularExpression.Options(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: all, using: { (result, flags, _) in
                matches.append(nsstr.substring(with: result!.range))
            })
        } catch {
            return matches
        }
        return matches
    }
    
}
