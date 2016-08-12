//
//  TelephoneTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TelephoneTableViewCell: UITableViewCell {

    @IBOutlet weak var telephoneNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
