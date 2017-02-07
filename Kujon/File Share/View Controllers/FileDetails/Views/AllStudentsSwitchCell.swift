//
//  AllStudentsSwitchCell.swift
//  Kujon
//
//  Created by Adam on 07.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class AllStudentsSwitchCell: UITableViewCell {


    @IBOutlet weak var allStudentsSwitch: UISwitch!


    override func awakeFromNib() {
        super.awakeFromNib()
        allStudentsSwitch.onTintColor = UIColor.kujonBlueColor()
        selectionStyle = .none
    }

}
