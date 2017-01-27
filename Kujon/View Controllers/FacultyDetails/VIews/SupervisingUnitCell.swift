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

    internal var supervisingUnit: SchoolPath? {
        didSet {
            if let unitName = supervisingUnit?.schoolName {
                supervisingUnitLabel.text = unitName
            }
        }
    }

    @IBOutlet weak var supervisingUnitLabel: UILabel!
        internal var delegate: SupervisingUnitCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

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
