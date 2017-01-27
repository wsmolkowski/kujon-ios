//
//  NavDrawerHeaderViewCellTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class NavDrawerHeaderViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var demoModeLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        updateDemoModeLabel()
    }

    private func updateDemoModeLabel() {
        demoModeLabel.isHidden = RestApiManager.APIMode == .production
    }
    
}
