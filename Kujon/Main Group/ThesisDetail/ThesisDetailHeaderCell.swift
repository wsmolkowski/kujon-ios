//
//  ThesisDetailHeaderCell.swift
//  Kujon
//
//  Created by Adam on 12.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var thesisTitleLabel: UILabel!
    @IBOutlet weak var thesisTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
