//
//  SupervisingUnitCell.swift
//  Kujon
//
//  Created by Adam on 16.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

protocol SupervisingUnitCellDelegate: class {
    func supervisingUnitCell(_ cell: SupervisingUnitCell, didTapSupervisingUnitWithId id:String)
}

class SupervisingUnitCell: UITableViewCell {
    
    @IBOutlet weak var arrowView: UIImageView!

    internal var supervisingUnit: SchoolPath? {
        didSet {
            if let unit = supervisingUnit {
                let unitName = unit.schoolName
                supervisingUnitLabel.text = unitName
                arrowView?.isHidden = false
            } else {
                supervisingUnitLabel.text = StringHolder.none
                arrowView?.isHidden = true
            }
        }
    }

    @IBOutlet weak var supervisingUnitLabel: UILabel!
        internal var delegate: SupervisingUnitCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        arrowView.tintColor = UIColor.blackWithAlpha(alpha: 0.3)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SupervisingUnitCell.unitLabelDidTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        supervisingUnitLabel.addGestureRecognizer(tapRecognizer)
    }

    func unitLabelDidTap() {
        if let unitId = supervisingUnit?.id {
            delegate?.supervisingUnitCell(self, didTapSupervisingUnitWithId: unitId)
        }
    }

}
