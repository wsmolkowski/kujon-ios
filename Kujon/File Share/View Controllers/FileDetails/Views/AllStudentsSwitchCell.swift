//
//  AllStudentsSwitchCell.swift
//  Kujon
//
//  Created by Adam on 07.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

protocol AllStudentsSwitchCellDelegate: class {

    func allStudentsSwitchCell(_ cell: AllStudentsSwitchCell?, didChangeSwitchState isOn: Bool)
}

class AllStudentsSwitchCell: UITableViewCell {


    internal weak var delegate: AllStudentsSwitchCellDelegate?
    @IBOutlet internal weak var allStudentsSwitch: UISwitch!


    override func awakeFromNib() {
        super.awakeFromNib()
        allStudentsSwitch.onTintColor = UIColor.kujonBlueColor()
        selectionStyle = .none
    }

    internal func setSwitchOn(_ on: Bool) {
        allStudentsSwitch.setOn(on, animated: true)
    }

    internal func isSwitchEnabled(_ isEnabled: Bool) {
        allStudentsSwitch.isEnabled = isEnabled
    }

    @IBAction internal func switchDidChangeState(_ sender: UISwitch) {
        delegate?.allStudentsSwitchCell(self, didChangeSwitchState: sender.isOn)
    }

}
