//
//  ArrowedLabelView.swift
//  Kujon
//
//  Created by Adam on 12.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class ArrowedLabelView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var arrowView: UIImageView!



    override func awakeFromNib() {
        super.awakeFromNib()
        arrowView.tintColor = UIColor.blackWithAlpha(alpha: 0.3)
    }

}
