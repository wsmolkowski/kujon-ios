//
//  LectureViewTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 13/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class LectureViewTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
