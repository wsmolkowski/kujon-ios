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
    @IBOutlet weak var thesisTypeLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var teachersStackView: UIStackView!
    

    weak var delegate: ThesisClickProtocol!

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

    private func propagateContentForThesis(_ thesis: Thesis) {
        titleLabel.text = thesis.title
        let authors: [String] = thesis.authors.map {
            $0.getNameWithTitles()
        }
        authorsLabel.text = authors.joined(separator: ", ")
        for user in thesis.supervisors{
            addReviewLabel(user:user)
        }
        thesisTypeLabel.text = thesis.type
        facultyLabel.text = thesis.faculty.name
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThesisCell.facultyTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        facultyLabel.addGestureRecognizer(tapGestureRecognizer)
        facultyLabel.isUserInteractionEnabled = true

    }

    private func addReviewLabel(user: SimpleUser) {
        let label = createLabel(name:user.getNameWithTitles())
        let tapRecognizer = IdentifiedTapGestureRecognizer(target: self, action: #selector(ThesisCell.headerDidTap))
        if(user.id != nil){
            tapRecognizer.stringId = user.id!
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            label.addGestureRecognizer(tapRecognizer)
        }
        self.teachersStackView.addArrangedSubview(label)
    }

    private func createLabel(name: String) -> UILabel {
        let yourLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        yourLabel.font = UIFont.kjnFontLatoMedium(size: 13.0)
        yourLabel.textColor = UIColor.black
        yourLabel.text = name
        yourLabel.sizeToFit()
        yourLabel.isUserInteractionEnabled = true

        return yourLabel
    }


    @objc private func headerDidTap(_ tapGestureRecognizer: IdentifiedTapGestureRecognizer) {
        if (thesis != nil  && delegate != nil) {
            delegate!.onTeacherClick(id: tapGestureRecognizer.stringId)
        }
    }

    @objc private func facultyTapped(_ sender: UITapGestureRecognizer) {
        if (thesis != nil) {
            delegate!.onFacultyClick(id: thesis!.faculty.id)
        }
    }
}
