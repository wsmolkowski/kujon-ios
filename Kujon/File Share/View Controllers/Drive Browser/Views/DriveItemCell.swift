//
//  DriveItemCell
//  Kujon
//
//  Created by Adam on 18.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

internal class DriveItemCell: UITableViewCell {

    internal var isCheckboxEnabled: Bool = false {
        didSet {
            isCheckboxEnabled ? enableCheckbox() : disableCheckbox()
        }
    }

    internal var isChecked: Bool = false {
        didSet {
            guard isCheckboxEnabled else { return }
            checkboxView.image = isChecked ? #imageLiteral(resourceName: "Float") : #imageLiteral(resourceName: "Circle")
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

    private var checkboxLeadingConstraint: NSLayoutConstraint?
    private var iconLeadingConstraint: NSLayoutConstraint?

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var checkboxView: UIImageView!

    @IBOutlet weak var topFullSeparator: UIView!
    @IBOutlet weak var bottomPartialSeparator: UIView!
    @IBOutlet weak var bottomFullSeparator: UIView!


    internal func configure(with item: GTLRDrive_File, cellPosition positionType: CellPositionType, enableCheckbox: Bool = false) {
        setIcon(for: item)
        propagateContent(from: item)
        isCheckboxEnabled = enableCheckbox

        switch positionType {
        case .top: setTopItem()
        case .middle: setMiddleItem()
        case .bottom: setBottomItem()
        case .topAndBottom: setTopAndBottomItem()
        }
    }

    internal func toggle() {
        guard isCheckboxEnabled else { return }
        isChecked = !isChecked
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    private func setIcon(for item: GTLRDrive_File) {
        if let mimeTypeString = item.mimeType {
            iconView.image = FileIconProvider.iconForMIMETypeString(mimeTypeString)
        }
    }

    private func enableCheckbox() {
        resetConstraints()
        checkboxView.isHidden = false

        checkboxLeadingConstraint = checkboxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        checkboxLeadingConstraint?.isActive = true

        iconLeadingConstraint = iconView.leadingAnchor.constraint(equalTo: checkboxView.trailingAnchor, constant: 16)
        iconLeadingConstraint?.isActive = true

        setNeedsLayout()
    }

    private func disableCheckbox() {
        resetConstraints()
        checkboxView.isHidden = true

        iconLeadingConstraint = iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        iconLeadingConstraint?.isActive = true

        setNeedsLayout()
    }

    private func resetConstraints() {
        checkboxLeadingConstraint?.isActive = false
        checkboxLeadingConstraint = nil
        iconLeadingConstraint?.isActive = false
        iconLeadingConstraint = nil
    }

    private func propagateContent(from item: GTLRDrive_File) {
        if let name = item.name {
            itemNameLabel.text = name
        }

        guard let createdDate = item.createdTime?.date, let modifiedDate = item.modifiedTime?.date
        else { return }

        if createdDate.equalToDate(modifiedDate) {
            let createdDateString = createdDate.isToday() ? createdDate.dateHoursToString() : createdDate.toFileEventDateTime()
            itemDescriptionLabel.text = "\(StringHolder.added) \(createdDateString)"
            return
        }

        let modifiedDateString = modifiedDate.isToday() ? modifiedDate.dateHoursToString() : modifiedDate.toFileEventDateTime()
        itemDescriptionLabel.text = "\(StringHolder.modified) \(modifiedDateString)"

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
