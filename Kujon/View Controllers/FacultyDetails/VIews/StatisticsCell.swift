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
            let none = StringHolder.none_lowercase

            programmesCountLabel.text = none

            coursesCountLabel.text = none

            employeesCountLabel.text = none

            if let programmeCount = stats.programmeCount {
                programmesCountLabel.text = "\(programmeCount)"
            }

            if let courseCount = stats.courseCount {
                coursesCountLabel.text = "\(courseCount)"
            }

            if let staffCount = stats.staffCount {
                employeesCountLabel.text = "\(staffCount)"
            }
        }
    }
    
}
