//
//  KierunekHeaderCell.swift
//  Kujon
//
//  Created by Adam on 30.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class KierunekHeaderCell: UITableViewCell {

    @IBOutlet weak var kierunekLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .white
        kierunekLabel.textColor = .black
    }

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.bottom, color:UIColor.lightGray(), thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }
    
}
