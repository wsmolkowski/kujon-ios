//
//  ItemCell.swift
//  Kujon
//
//  Created by Adam on 08.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
