//
//  CheckboxCell.swift
//  Kujon
//
//  Created by Adam on 21.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class CheckboxCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!

    @IBOutlet weak var topFullSeparator: UIView!
    @IBOutlet weak var bottomFullSeparator: UIView!
    @IBOutlet weak var bottomPartialSeparator: UIView!


    internal var isChecked: Bool = false {
        didSet {
            checkboxImageView.image = isChecked ? #imageLiteral(resourceName: "Float") : #imageLiteral(resourceName: "Circle")
        }
    }

    private var isTopFullSeparatorEnabled: Bool = false {
        didSet {
            topFullSeparator.isHidden = !isTopFullSeparatorEnabled
        }
    }

    private var isBottomPartialSeparatorEnabled: Bool = false {
        didSet {
            bottomPartialSeparator.isHidden = !isBottomPartialSeparatorEnabled
        }
    }

    private var isBottomFullSeparatorEnabled: Bool = false {
        didSet {
            bottomFullSeparator.isHidden = !isBottomFullSeparatorEnabled
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    internal func configure(with title: String, cellPosition positionType: CellPositionType, isChecked: Bool) {

        self.isChecked = isChecked
        self.titleLabel.text = title

        switch positionType {
        case .top: setTopItem()
        case .middle: setMiddleItem()
        case .bottom: setBottomItem()
        case .topAndBottom: setTopAndBottomItem()
        }
    }

    internal func toggle() {
        isChecked = !isChecked
    }

    private func setTopItem() {
        isTopFullSeparatorEnabled = true
        isBottomPartialSeparatorEnabled = true
        isBottomFullSeparatorEnabled = false
    }

    private func setMiddleItem() {
        isTopFullSeparatorEnabled = false
        isBottomPartialSeparatorEnabled = true
        isBottomFullSeparatorEnabled = false
    }

    private func setBottomItem() {
        isTopFullSeparatorEnabled = false
        isBottomPartialSeparatorEnabled = false
        isBottomFullSeparatorEnabled = true
    }

    private func setTopAndBottomItem() {
        isTopFullSeparatorEnabled = true
        isBottomPartialSeparatorEnabled = false
        isBottomFullSeparatorEnabled = true
    }

}
