//
//  ThesesTableViewCell.swift
//  Kujon
//
//  Created by Adam on 06.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

protocol ThesisCellDelegate :class {

    func thesisCell(_ cell:ThesisCell, didTapFacultyWithId id: String)
    func thesisCell(_ cell:ThesisCell, didTapSupervisorWithId id: String)
    func thesisCell(_ cell:ThesisCell, didTapAuthorWithId id: String)
}


class ThesisCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ThesisCellDelegate?

    var thesis: Thesis? {
        didSet {
            if let _ = thesis {
                tableView.reloadData()
            }
        }
    }

    private enum SectionMap: Int {
        case header = 0
        case authors
        case supervisors
        case faculty
        case sectionSeparator

        static func sectionForIndex(_ index:Int) -> SectionMap {
            if let section = SectionMap(rawValue: index) {
                return section
            }
            fatalError("Invalid section index")
        }
    }

    private let itemCellId: String = "itemCellId"
    private let headerCellId: String = "headerCellId"
    private let sectionSeparatorCellId: String = "separatorCellId"

    static let itemCellHeight: CGFloat = 43.0
    static let itemHeaderHeight: CGFloat = 30.0
    static let headerCellHeight: CGFloat = 76.0
    static let sectionSeparatorHeight: CGFloat = 44
    static let sectionsCount: Int = 5

    static func calculateCellHeightForThesis(_ thesis: Thesis) -> CGFloat {
        let authorsCount = CGFloat(thesis.authors.count)
        let supervisorsCount = CGFloat(thesis.supervisors.count)
        let authorCellsHeight = (authorsCount * itemCellHeight) + itemHeaderHeight
        let supervisorCellsHeight = (supervisorsCount * itemCellHeight) + itemHeaderHeight
        let facultyCellsHeight = itemCellHeight + itemHeaderHeight
        return headerCellHeight + sectionSeparatorHeight + authorCellsHeight + supervisorCellsHeight + facultyCellsHeight
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureTbleView()
    }

    func configureTbleView() {
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"ArrowedItemCell", bundle:nil), forCellReuseIdentifier: itemCellId)
        tableView.register(UINib(nibName:"ThesisDetailHeaderCell", bundle:nil), forCellReuseIdentifier: headerCellId)
        tableView.register(UINib(nibName:"SeparatorCell", bundle:nil), forCellReuseIdentifier: sectionSeparatorCellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return ThesisCell.sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .header: return 1
        case .authors: return thesis?.authors.count ?? 0
        case .supervisors: return thesis?.supervisors.count ?? 0
        case .faculty: return 1
        case .sectionSeparator: return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)

        switch (section) {
        case .header: return nil
        case .authors: return sectionForTitle(StringHolder.authors)
        case .supervisors: return sectionForTitle(StringHolder.supervisors)
        case .faculty: return sectionForTitle(StringHolder.faculty)
        case .sectionSeparator: return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = SectionMap.sectionForIndex(section)
        switch section {
        case .header: return 0.0
        case .sectionSeparator: return 0.0
        default: return ThesisCell.itemHeaderHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .header: return ThesisCell.headerCellHeight
        case .sectionSeparator: return ThesisCell.sectionSeparatorHeight
        default: return ThesisCell.itemCellHeight
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .header: return headerCellForIndexPath(indexPath)
        case .sectionSeparator : return sectionSeparatorForIndexPath(indexPath)
        default: return itemCellForIndexPath(indexPath)
        }
    }

    private func headerCellForIndexPath(_ indexPath: IndexPath) -> ThesisDetailHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! ThesisDetailHeaderCell
        cell.thesisTitleLabel.text = thesis?.title
        cell.thesisTypeLabel.text = thesis?.type
        return cell
    }

    private func itemCellForIndexPath(_ indexPath: IndexPath) -> ArrowedItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! ArrowedItemCell
        let section = SectionMap.sectionForIndex(indexPath.section)
        let labelText: String?

        switch section {
        case .header: labelText = nil
        case .authors: labelText = thesis?.authors[indexPath.row].getNameWithTitles()
        case .supervisors: labelText = thesis?.supervisors[indexPath.row].getNameWithTitles()
        case .faculty: labelText = thesis?.faculty.name
        case .sectionSeparator: labelText = nil
        }
        cell.titleLabel.text = labelText
        return cell
    }

    func sectionSeparatorForIndexPath(_ indexPath: IndexPath) -> SeparatorCell {
        return tableView.dequeueReusableCell(withIdentifier: sectionSeparatorCellId, for: indexPath) as! SeparatorCell
    }

    func sectionForTitle(_ text: String) -> UIView {
        let sectionView: SectionHeader = Bundle.main.loadNibNamed("SectionHeader", owner: nil, options: nil)?.first as! SectionHeader
        sectionView.titleLabel.text = text
        return sectionView
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .authors:
            if let authorId = thesis?.authors[indexPath.row].id {
                delegate?.thesisCell(self, didTapAuthorWithId: authorId)
            }
        case .supervisors:
            if let supervisorId = thesis?.supervisors[indexPath.row].id {
                delegate?.thesisCell(self, didTapSupervisorWithId: supervisorId)
            }
        case .faculty:
            if let facultyId = thesis?.faculty.id {
                delegate?.thesisCell(self, didTapFacultyWithId: facultyId)
            }
        default: return
        }
    }

}


