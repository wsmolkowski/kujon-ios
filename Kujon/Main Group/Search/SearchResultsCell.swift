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
    internal var title: String? {
        didSet {
            if let title = title {
                title.attributedStringFromHTMLWithFont(UIFont.kjnFontLatoRegularSize(15.0)!, color: UIColor.color2A333E()) { [weak self] attributedString in
                    self?.titleLabel.attributedText = attributedString
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.Top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }


}
