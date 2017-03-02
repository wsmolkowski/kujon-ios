//
//  ProgrammeCell.swift
//  Kujon
//
//  Created by Adam on 02.03.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class ProgrammeCell: UITableViewCell {

    @IBOutlet weak var programmeName: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var statusDescription: UILabel!

    override var frame: CGRect {
        didSet {
            self.layer.addBorder(UIRectEdge.top,color:UIColor.lightGray(),thickness: 1)
        }
    }

    override var layer: CALayer {
        return super.layer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    internal func configureCell(with programme: StudentProgramme) {

        if let name = programme.programme.nameShort {
            programmeName.text = name
        }

        if let status = programme.status {
            statusDescription.text = status.statusDescription
            statusIcon.image = status.iconImage
        }


    }
    
}
