//
//  MessageCell.swift
//  Kujon
//
//  Created by Adam on 25.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class MessageCell: GoFurtherViewCellTableViewCell {

    var message: Message? {
        didSet {
            if let message = message {
                senderLabel.text = message.from
                dateLabel.text = Date.formattedPolishStringFromDateFormatWithClockString(message.createdTime)
            }
        }
    }

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}