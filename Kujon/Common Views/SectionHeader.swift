//
//  SectionHeader.swift
//  Kujon
//
//  Created by Adam on 09.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SectionHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorTop: UIView!
    @IBOutlet weak var separatorBottom: UIView!

    internal var separatorTopEnabled: Bool = true {
        didSet {
            separatorTop.isHidden = !separatorTopEnabled
        }
    }

    internal var separatorBottomEnabled: Bool = false {
        didSet {
            separatorBottom.isHidden = !separatorBottomEnabled
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorTopEnabled = true
        separatorBottomEnabled = false
    }

}
