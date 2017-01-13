//
//  TeacherHeaderTableViewCell.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 15/08/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol TeacherHeaderCellDelegate: class {

    func teacherHeaderCell( _ cell: TeacherHeaderTableViewCell, didSelectEmploymentPosition position: EmploymentPosition)

    func teacherHeaderCell( _ cell: TeacherHeaderTableViewCell, didDidSelectOpenExternalURL url: URL)
}

class TeacherHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherInterestLabel: UILabel!
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherStatusLabel: UILabel!
    @IBOutlet weak var teacherConsultationLabel: UILabel!
    @IBOutlet weak var teacherHomepageLabel: UILabel!
    @IBOutlet weak var teacherRoomLabel: UILabel!
    @IBOutlet weak var checkEmailURLButton: UIButton!
    @IBOutlet weak var employmentStack: UIStackView!
    @IBOutlet weak var openLinkButton: UIButton!
    private var openLinkURL: URL?
    internal weak var delegate: TeacherHeaderCellDelegate?
    private let htmlLinkMark = "<a"
    private let htmlURLMark = "href"

    internal var teacherEmailURL: String? {
        didSet {
            updateButtonState()
        }
    }

    internal var positions: [EmploymentPosition]? {
        didSet {
            guard let positions = positions, !positions.isEmpty else {
                employmentStack.heightAnchor.constraint(equalToConstant: 25).isActive = true
                return
            }
            setupPositions(positions)
        }
    }

    internal var teacherConsultation: String? {
        didSet {
            guard let consultation = teacherConsultation else {
                return
            }
            if consultation.contains(htmlLinkMark) && consultation.contains(htmlURLMark){
                guard let consultationURL = retieveURL(from: consultation) else {
                    return
                }
                setupConsultationButton(with: consultationURL)
                return
            }
            setupConsultationLabel(with: consultation)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonState()
        openLinkButton.isHidden = true
    }

    private func setupPositions(_ positions: [EmploymentPosition]) {
        for (index, position) in positions.enumerated() {
            guard let item = Bundle.main.loadNibNamed("ArrowedLabelView", owner: self, options: nil)?.first as? ArrowedLabelView else {
                return
            }
            let tapRecognizer = IdentifiedTapGestureRecognizer(target: self, action: #selector(TeacherHeaderTableViewCell.positionLabelDidTap(_:)))
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.id = index
            item.addGestureRecognizer(tapRecognizer)
            item.titleLabel.text = position.faculty.name + ", " + position.position.name
            employmentStack.addArrangedSubview(item)
        }
    }

    internal func positionLabelDidTap(_ tapRecognizer:IdentifiedTapGestureRecognizer) {
        let index = tapRecognizer.id
        if let positions = positions {
            delegate?.teacherHeaderCell(self, didSelectEmploymentPosition: positions[index])
        }
    }

    @IBAction func checkEmailURLButtonDidTap(_ sender: UIButton) {
        if let teacherEmailURL = teacherEmailURL,
            let URL = URL(string: teacherEmailURL, relativeTo: nil) {
            UIApplication.shared.openURL(URL)
        }
    }

    private func updateButtonState() {
        checkEmailURLButton.isEnabled = teacherEmailURL != nil
    }

    private func retieveURL(from html: String) -> URL? {
        let urlMatches = html.findAllMatches(pattern: .url)
        if urlMatches.isEmpty {
            return nil
        }
        return URL(string:urlMatches.first!)
    }

    private func setupConsultationButton(with url: URL) {
        teacherConsultationLabel.text = ""
        openLinkURL = url
        openLinkButton.isHidden = false

    }


    private func setupConsultationLabel(with description: String) {
        teacherConsultationLabel.text = description
    }

    @IBAction func openLinkButtonDidTap(_ sender: UIButton) {
        if let url = openLinkURL {
            delegate?.teacherHeaderCell(self, didDidSelectOpenExternalURL: url)
        }
    }

    
}


