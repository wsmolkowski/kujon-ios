//
//  StudentHeaderTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 17/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class StudentHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var studentIndexLabel: UILabel!

    @IBOutlet weak var studentAccountLabel: UILabel!
    @IBOutlet weak var studentStatusLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
