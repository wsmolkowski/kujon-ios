//
//  FacultieHeaderTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class FacultieHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var facultieImageView: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var facultieNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
