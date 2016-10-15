//
//  TeacherHeaderTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 15/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class TeacherHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var teacherEmployeStatus: UILabel!
    @IBOutlet weak var teacherInterestLabel: UILabel!
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherStatusLabel: UILabel!

    @IBOutlet weak var teacherConsultationLabel: UILabel!
    @IBOutlet weak var teacherHomepageLabel: UILabel!
    @IBOutlet weak var teacherRoomLabel: UILabel!
    @IBOutlet weak var checkEmailURLButton: UIButton!

    internal var teacherEmailURL: String? {
        didSet {
            updateButtonState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonState()
    }

    @IBAction func checkEmailURLButtonDidTap(_ sender: UIButton) {

        if let teacherEmailURL = teacherEmailURL,
            let URL = URL(string: teacherEmailURL, relativeTo: nil) {
            UIApplication.shared.openURL(URL)
        }
    }

    fileprivate func updateButtonState() {
        checkEmailURLButton.isEnabled = teacherEmailURL != nil
    }

}
