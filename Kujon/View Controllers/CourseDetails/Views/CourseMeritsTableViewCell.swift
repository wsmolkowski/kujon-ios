//
//  CourseMeritsTableViewCell.swift
//  Kujon
//
//  Created by Adam on 24.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit


protocol CourseMeritsTableViewCellDelegate: class {

    func courseMeritsCellDidChangeContent(_ cell: CourseMeritsTableViewCell)
}

class CourseMeritsTableViewCell: UITableViewCell {

    internal weak var delegate: CourseMeritsTableViewCellDelegate?
    private let passusLength: Int = 150

    @IBOutlet weak var upperSeparator: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    private var isContentLabelFolded: Bool = true
    private var content = String()
    private var contentPreview: String { return passus(from: content) }

    @IBOutlet weak var moreButton: UIButton!

    // MARK: - Initial section

    override func awakeFromNib() {
        super.awakeFromNib()

        let descriptionTap = UITapGestureRecognizer(target: self, action: #selector(CourseMeritsTableViewCell.descriptionLabelDidTap(_:)))
        descriptionTap.numberOfTapsRequired = 1
        contentLabel.addGestureRecognizer(descriptionTap)
        contentLabel.isUserInteractionEnabled = true
        upperSeparator.backgroundColor = UIColor.lightGray()

    }

    internal func configureCellWith(title: String, content: String, showUpperSeparator: Bool = false) {
        titleLabel.text = title
        self.content = content.trim()
        contentLabel.text = contentPreview
        moreButton.isHidden = content.characters.count <= passusLength
        moreButton.setTitle(StringHolder.more, for: .normal)
        upperSeparator.isHidden = !showUpperSeparator
    }

    // MARK: - Actions

    func descriptionLabelDidTap(_ tap: UITapGestureRecognizer) {
        updateContentLabelState()
    }


    @IBAction func moreButtonDidTap(_ sender: UIButton) {
        updateContentLabelState()
    }

    private func updateContentLabelState() {
        self.contentLabel.text = self.isContentLabelFolded ? self.content : self.contentPreview
        self.isContentLabelFolded = !self.isContentLabelFolded
        self.moreButton.setTitle(self.isContentLabelFolded ? StringHolder.more : StringHolder.less, for: .normal)
        self.delegate?.courseMeritsCellDidChangeContent(self)
    }

    // MARK: - Helpers

    private func passus(from text: String) -> String {
        if text.characters.count > passusLength {
            let index = text.index(text.startIndex, offsetBy: passusLength)
            return text.substring(to: index).trim() + "..."
        }
        return text
    }

}
