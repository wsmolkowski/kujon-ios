//
//  StatisticsCell.swift
//  Kujon
//
//  Created by Adam on 16.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell {

    @IBOutlet weak var programmesCountLabel: UILabel!

    @IBOutlet weak var coursesCountLabel: UILabel!

    @IBOutlet weak var employeesCountLabel: UILabel!


    internal var stats: SchoolStats? {
        didSet {
            guard let stats = stats else {
                return
            }
            programmesCountLabel.text = "\(stats.programmeCount)"
            coursesCountLabel.text = "\(stats.courseCount)"
            employeesCountLabel.text = "\(stats.staffCount)"
        }
    }
    
}
