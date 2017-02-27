//
//  StudentEmailCell.swift
//  Kujon
//
//  Created by Adam on 27.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class StudentEmailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override var frame: CGRect {
        didSet {
            layer.addBorder(UIRectEdge.top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }

}
