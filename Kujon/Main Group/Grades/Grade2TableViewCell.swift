//
//  Grade2TableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 17/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class Grade2TableViewCell: GoFurtherViewCellTableViewCell {

    @IBOutlet weak var textGradeLabel: UILabel!
    @IBOutlet weak var secDescLabel: UILabel!
    @IBOutlet weak var gradeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    internal var grade: Grade? {
        didSet {
            if let grade = grade {
                propagateGrade(grade)
            }
        }
    }

    internal var courseName: String? {
        didSet {
            if let courseName = courseName {
                descriptionLabel.text = courseName
            }
        }
    }

    private func propagateGrade(_ grade:Grade) {
        let gradeColor = grade.valueSymbol == "2" || grade.valueSymbol == "NZAL" ? UIColor.red : UIColor.black
        textGradeLabel.textColor = gradeColor
        textGradeLabel.text = grade.valueDescription
        gradeNumberLabel.textColor = gradeColor
        gradeNumberLabel.text = grade.valueSymbol
        secDescLabel.text = grade.getClassType() + "  " + StringHolder.termin  + " " + String(grade.examSessionNumber)
    }

}



