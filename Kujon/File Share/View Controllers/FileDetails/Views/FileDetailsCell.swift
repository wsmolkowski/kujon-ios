//
//  FileDetailsCell.swift
//  Kujon
//
//  Created by Adam on 07.02.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import UIKit

class FileDetailsCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileTypeLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var fileOwnerLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    internal func configure(with file: APIFile) {
        fileNameLabel.text = file.fileName
        fileTypeLabel.text = FileTypeDescriptionProvider.descriptionForMIMETypeString(file.contentType)

        if let firstName = file.firstName, let lastName = file.lastName {
            fileOwnerLabel.text = firstName + " " + lastName
        }

        var fileSize = file.fileSize ?? "0.00"
        if !fileSize.hasSuffix(StringHolder.megabytes_short) && !fileSize.hasSuffix(StringHolder.kilobytes_short) {
            fileSize += " " + StringHolder.megabytes_short
        }
        fileSizeLabel.text = fileSize

        if  let createdTimeString = file.createdTime,
            let date = Date.stringToDateWithClock(createdTimeString) {
            let dateFormatted = date.toFileEventDateTime()
            createdDateLabel.text = dateFormatted
        }
    }

}
