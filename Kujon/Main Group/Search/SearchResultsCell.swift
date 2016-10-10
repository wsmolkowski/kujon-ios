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
                title.attributedStringFromHTMLWithFont() { [weak self] attributedString in
                    guard let mutableAttributedString = attributedString?.mutableCopy() as? NSMutableAttributedString else {
                        return
                    }
                    let attributes: [String:AnyObject] = [
                        NSFontAttributeName: UIFont.kjnFontLatoRegularSize(15.0)!,
                        NSForegroundColorAttributeName: UIColor.color2A333E()
                    ]
                    mutableAttributedString.addAttributes(attributes, range: NSMakeRange(0, mutableAttributedString.length))
                    self?.titleLabel.attributedText = mutableAttributedString.copy() as? NSAttributedString
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
