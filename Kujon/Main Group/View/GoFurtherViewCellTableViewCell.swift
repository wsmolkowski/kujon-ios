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


    override func awakeFromNib() {
        super.awakeFromNib()


    }
    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.Top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
