//
//  GoFurtherViewCellTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 13/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class GoFurtherViewCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var plainLabel: UILabel!

    @IBOutlet weak var arrow: UIImageView!

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
