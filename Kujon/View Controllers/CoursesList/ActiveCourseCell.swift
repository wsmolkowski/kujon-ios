//
//  CourseTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 27/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ActiveCourseCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var filesNumberLabel: UILabel!

    @IBOutlet weak var courseNameLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var folderIconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var folderIcon: UIImageView!

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

    internal func configure(courseName: String, filesNumber: String, showFolderIcon: Bool) {
        courseNameLabel.text = courseName
        filesNumberLabel.text = filesNumber
        showFolderIcon ? showFolder() : hideFolder()
    }

    private func showFolder() {
        resetConstraints()
        folderIcon.isHidden = false

        courseNameLabelLeadingConstraint = courseNameLabel.leadingAnchor.constraint(equalTo: folderIcon.trailingAnchor, constant: 8)
        courseNameLabelLeadingConstraint?.isActive = true

        folderIconLeadingConstraint = folderIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        folderIconLeadingConstraint?.isActive = true
        setNeedsLayout()
    }

    private func hideFolder() {
        resetConstraints()
        folderIcon.isHidden = true

        courseNameLabelLeadingConstraint = courseNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        courseNameLabelLeadingConstraint?.isActive = true
        setNeedsLayout()
    }

    private func resetConstraints() {
        courseNameLabelLeadingConstraint?.isActive = false
        courseNameLabelLeadingConstraint = nil
        folderIconLeadingConstraint?.isActive = false
        folderIconLeadingConstraint = nil
    }

}

