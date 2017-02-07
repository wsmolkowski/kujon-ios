//
//  SeparatorCell.swift
//  Kujon
//
//  Created by Adam on 09.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SeparatorCell: UITableViewCell {

    @IBOutlet weak var optionalTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        isUserInteractionEnabled = false
        backgroundColor = UIColor.greyBackgroundColor()
    }

    
}
