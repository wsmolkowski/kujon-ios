//
//  TeacherDetailsTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 16/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherInterestLabel: UILabel!
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherStatusLabel: UILabel!
    @IBOutlet weak var teacherEmailLabel: UILabel!
    @IBOutlet weak var teacherConsultationLabel: UILabel!
    @IBOutlet weak var teacherHomepageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
