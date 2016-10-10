//
//  SearchTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 04/10/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell{

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        // search button
        let title = StringHolder.searchButtonLabel

        let attributesNormalState: [String:AnyObject]? = [
            NSFontAttributeName: UIFont.kjnFontLatoMediumSize(17)!,
            NSForegroundColorAttributeName: UIColor.color3FBAD9(alpha: 0.4)
        ]

        let titleStateNormal = NSAttributedString(string: title, attributes: attributesNormalState)
        button.setAttributedTitle(titleStateNormal, forState: .Normal)

        let attributesFocusedState: [String:AnyObject]? = [
            NSFontAttributeName: UIFont.kjnFontLatoMediumSize(17)!,
            NSForegroundColorAttributeName: UIColor.color3FBAD9(alpha: 1.0)
        ]

        let titleStateFocused = NSAttributedString(string: title, attributes: attributesFocusedState)
        button.setAttributedTitle(titleStateFocused, forState: .Focused)

        //button.state = .Focused

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
