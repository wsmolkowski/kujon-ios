//
//  InactiveTermCell
//  Kujon
//
//  Created by Wojciech Maciejewski on 12/07/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class InactiveTermCell: UITableViewCell {


    @IBOutlet weak var endindTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var termNumberLabel: UILabel!
    @IBOutlet weak var termNameLabel: UILabel!


    // MARK: Initial section

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }

    internal func configureCell(with term: Term) {
        endDateLabel.text = term.endDate
        endindTimeLabel.text = term.finishDate
        startDateLabel.text = term.startDate
        termNameLabel.text = term.name
        termNumberLabel.text = term.termId
    }
}
