//
//  CourseTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ActiveCourseCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var filesNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    internal func configure(courseName: String, filesNumber: String) {
        courseNameLabel.text = courseName
        filesNumberLabel.text = filesNumber
    }

}
