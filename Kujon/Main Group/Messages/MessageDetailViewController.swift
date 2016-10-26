//
//  MessageDetailViewController.swift
//  Kujon
//
//  Created by Adam on 26.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    internal var message: Message?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = StringHolder.details

        if let message = message {
            senderLabel.text = message.from
            dateLabel.text = Date.formattedPolishStringFromDateFormatWithClockString(message.createdTime)
            messageLabel.text = message.message
        }
    }
    
}
