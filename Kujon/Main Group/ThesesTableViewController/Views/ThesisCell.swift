//
//  ThesesTableViewCell.swift
//  Kujon
//
//  Created by Adam on 06.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var reviewersLabel: UILabel!
    @IBOutlet weak var thesisTypeLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!

    var thesis: Thesis? {
        didSet {
            if let thesis = thesis {
                propagateContentForThesis(thesis)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    fileprivate func propagateContentForThesis(_ thesis: Thesis) {
        titleLabel.text = thesis.title
        let authors: [String] = thesis.authors.map { $0.getNameWithTitles() }
        authorsLabel.text = authors.joined(separator: ", ")
        let reviewers: [String] = thesis.supervisors.map { $0.getNameWithTitles() }
        reviewersLabel.text = reviewers.joined(separator: ", ")
        thesisTypeLabel.text = thesis.type
        facultyLabel.text = thesis.faculty.name
    }
}
