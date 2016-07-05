//
//  UserDetailsTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 05/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var indexNumberLabel: UILabel!
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var schoolImageVirw: UIImageView!
    @IBOutlet weak var studentStatusLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
