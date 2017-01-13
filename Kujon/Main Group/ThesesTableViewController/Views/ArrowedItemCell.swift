//
//  ArrowedItemCell.swift
//  Kujon
//
//  Created by Adam on 09.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ArrowedItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }
    
}
