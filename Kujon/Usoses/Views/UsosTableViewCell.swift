//
//  UsosTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class UsosTableViewCell: UITableViewCell {



    @IBOutlet weak var usosImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
 
    
}
