//
//  Grade2TableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 17/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class Grade2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var textGradeLabel: UILabel!
    
    @IBOutlet weak var secDescLabel: UILabel!
    @IBOutlet weak var gradeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
