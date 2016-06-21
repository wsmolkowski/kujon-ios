//
//  HeaderViewTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 21/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class HeaderViewTableViewCell: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func instanceFromNib() -> HeaderViewTableViewCell {
        return UINib(nibName: "HeaderViewTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HeaderViewTableViewCell
    }
    
}
