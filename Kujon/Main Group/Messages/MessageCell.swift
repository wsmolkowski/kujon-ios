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
                if let dateString = Date.stringFromFormatWithClockString(message.createdTime) {
                    dateLabel.text = dateString
                }
            }
        }
    }

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
