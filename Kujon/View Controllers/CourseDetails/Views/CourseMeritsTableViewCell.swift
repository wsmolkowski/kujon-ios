//
//  CourseMeritsTableViewCell.swift
//  Kujon
//
//  Created by Adam on 24.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class CourseMeritsTableViewCell: GoFurtherViewCellTableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bibliographyLabel: UILabel!
    @IBOutlet weak var assessmentCriteriaLabel: UILabel!

    internal func configureCellWith(description:String, bibliography:String, assessmentCriteria:String) {
        descriptionLabel.text = description
        bibliographyLabel.text = bibliography
        assessmentCriteriaLabel.text = assessmentCriteria
        setNeedsLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
