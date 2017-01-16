//
//  FacultieHeaderTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol FacultyHeaderTableViewCellDelegate: class {

    func facultyHeaderCell(_ cell:FacultieHeaderTableViewCell, didTapPinButton button:UIButton)
}


class FacultieHeaderTableViewCell: UITableViewCell {

    internal weak var delegate: FacultyHeaderTableViewCellDelegate?

    @IBOutlet weak var facultieImageView: UIImageView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var facultieNameLabel: UILabel!


    @IBAction func pinButtonDidTap(_ sender: UIButton) {
        delegate?.facultyHeaderCell(self, didTapPinButton: sender)
    }
    
}
