//
//  UsosTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UsosTableViewCell: UITableViewCell {

    @IBOutlet weak var usosImageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var enabled: Bool = false {
        didSet {
            updateCellState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        updateCellState()
        backgroundColor = UIColor.greyBackgroundColor()

    }

    fileprivate func updateCellState() {
        label.alpha = enabled ? 1.0 : 0.4
        usosImageView.alpha = enabled ? 1.0 : 0.4
    }


}
