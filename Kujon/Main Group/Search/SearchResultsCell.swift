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
                let cleanTitle = String.stripHTMLFromString(title)
                self.titleLabel.text = cleanTitle
                self.titleLabel.attributedText = cleanTitle.attributedStringWithFont(UIFont.kjnFontLatoRegular(size:15.0)!, color: .color2A333E())
                }
            }

        }
    }
