//
//  SharedFileCell.swift
//  Kujon
//
//  Created by Adam on 03.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class SharedFileCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var addedByLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    internal func configure(with item: APIFile, cellPosition positionType: CellPositionType) {
        propagateContent(from: item)

        switch positionType {
        case .top: setTopItem()
        case .middle: setMiddleItem()
        case .bottom: setBottomItem()
        case .topAndBottom: setTopAndBottomItem()
        case .universal: fatalError("Not implemented")
        }
    }

    private func propagateContent(from item: APIFile) {
        iconImageView.image = FileIconProvider.iconForMIMETypeString(item.contentType)
        fileNameLabel.text = item.fileName
        sharedLabel.text = shareStringForItem(item)

        var fileSize = item.fileSize ?? "0.00"
        if !fileSize.hasSuffix(StringHolder.megabytes_short) && !fileSize.hasSuffix(StringHolder.kilobytes_short) {
            fileSize += " " + StringHolder.megabytes_short
        }
        fileSizeLabel.text = fileSize


        if  let createdTimeString = item.createdTime,
            let date = Date.stringToDateWithClock(createdTimeString) {
            let dateFormatted = date.isToday() ? date.toFileEventTime() : date.toFileEventDateTime()
            dateLabel.text = dateFormatted
        }

        if let firstName = item.firstName, let lastName = item.lastName {
            addedByLabel.text = "Dodany przez \(firstName) \(lastName)"
        }
    }

    private func shareStringForItem(_ item: APIFile) -> String {
        if  let sharedWith = item.shareOptions.sharedWith {
            switch sharedWith {
            case .all:
                return StringHolder.all
            case .list:
                let sharedWithIds = item.shareOptions.sharedWithIds ?? []
                let shareCount = sharedWithIds.count
                return "\(shareCount)"
            case .none:
                return StringHolder.none
            }
        }
        return StringHolder.none
    }

    // MARK: - Handle separators configuration

    @IBOutlet weak var topFullSeparator: UIView!
    @IBOutlet weak var bottomPartialSeparator: UIView!
    @IBOutlet weak var bottomFullSeparator: UIView!

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
