//
//  NavDrawerHeaderViewCellTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class NavDrawerHeaderViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
