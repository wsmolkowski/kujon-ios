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
                    self.titleLabel.text = title
                    self.titleLabel.attributedText = HTMLParser.parseHTMLString(title, usingRegularFont: UIFont.kjnFontLatoRegular(size: 15.0), andBoldFont: UIFont.kjnFontLatoBold(size: 15.0))
                }
            }
        }
    }
