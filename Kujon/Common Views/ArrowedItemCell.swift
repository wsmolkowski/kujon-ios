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

    @IBOutlet weak var topSeparator: UIView!

    func addTopSeparator() {
        topSeparator.isHidden = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        topSeparator.isHidden = true
    }

}
