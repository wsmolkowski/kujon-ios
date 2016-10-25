//
//  MessageCell.swift
//  Kujon
//
//  Created by Adam on 25.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    var message: Message? {
        didSet {
            if let message = message {
                senderLabel.text = message.from
                dateLabel.text = message.createdTime
                messageLabel.text = message.message
            }
        }
    }

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layer.cornerRadius = 10

    }

}
