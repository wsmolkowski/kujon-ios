//
//  SearchResultsCell.swift
//  Kujon
//
//  Created by Adam on 10.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchResultsCell: GoFurtherViewCellTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
     var title: String? {
        didSet {
            if let title = title {
                title.attributedStringFromHTML() { [weak self] attributedString in
                    guard let mutableAttributedString = attributedString?.mutableCopy() as? NSMutableAttributedString else {
                        return
                    }
                    let attributes: [String:AnyObject] = [
                        NSFontAttributeName: UIFont.kjnFontLatoRegular(size:15.0)!,
                        NSForegroundColorAttributeName: UIColor.color2A333E()
                    ]
                    mutableAttributedString.addAttributes(attributes, range: NSMakeRange(0, mutableAttributedString.length))
                    self?.titleLabel.attributedText = mutableAttributedString.copy() as? NSAttributedString
                }
            }
        }
    }

}