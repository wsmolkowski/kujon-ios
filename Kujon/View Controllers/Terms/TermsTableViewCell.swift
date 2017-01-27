//
//  TermsTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TermsTableViewCell: UITableViewCell {


    @IBOutlet weak var endindTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var termActiveLabel: UILabel!
    @IBOutlet weak var termNumberLabel: UILabel!
    @IBOutlet weak var termNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
