//
//  ThesisDetailViewController.swift
//  Kujon
//
//  Created by Adam on 12.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesisDetailTableViewController: UITableViewController {

    enum SectionMap: Int {
        case Header = 0
        case Authors
        case Supervisors
        case Faculty

        static func sectionForIndex(index:Int) -> SectionMap {
            switch index {
            case Header.rawValue: return Header
            case Authors.rawValue: return Authors
            case Supervisors.rawValue: return Supervisors
            case Faculty.rawValue: return Faculty
            default: fatalError("Invalid section index")
            }
        }
    }

    let itemCellId: String = "itemCellId"
    let itemCellHeight: CGFloat = 50.0
    let headerCellId: String = "headerCellId"
    let headerCellHeight: CGFloat = 200.0
    let sectionsCount: Int = 4

    var thesis: ThesisSearchInside?

    // MARK: - Initial section

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.thesisDetailTitle
        configureTableView()
    }

    private func configureTableView() {
        tableView.registerNib(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        tableView.registerNib(UINib(nibName: "ThesisDetailHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellId)
        tableView.separatorStyle = .None
        tableView.backgroundColor = .greyBackgroundColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .Header: return 1
        case .Authors: return thesis?.authors?.count ?? 0
        case .Supervisors: return thesis?.supervisors?.count ?? 0
        case .Faculty: return 1
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)

        switch (section) {
        case .Header: return nil
        case .Authors: return createLabelForSectionTitle(StringHolder.authors)
        case .Supervisors: return createLabelForSectionTitle(StringHolder.supervisors)
        case .Faculty: return createLabelForSectionTitle(StringHolder.faculty)
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = SectionMap.sectionForIndex(section)
        return section == .Header ? 0.0 : itemCellHeight
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .Header ? headerCellHeight : itemCellHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return indexPath.section == 0 ? headerCellForIndexPath(indexPath) : itemCellForIndexPath(indexPath)
    }

    private func headerCellForIndexPath(indexPath: NSIndexPath) -> ThesisDetailHeaderCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(headerCellId, forIndexPath: indexPath) as! ThesisDetailHeaderCell
        cell.thesisTitleLabel.text = thesis?.title
        cell.thesisTypeLabel.text = thesis?.type
        return cell
    }

    private func itemCellForIndexPath(indexPath: NSIndexPath) -> GoFurtherViewCellTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemCellId, forIndexPath: indexPath) as! GoFurtherViewCellTableViewCell
        let section = SectionMap.sectionForIndex(indexPath.section)
        let labelText: String?

        switch section {
        case .Header: labelText = nil
        case .Authors: labelText = thesis?.authors?[indexPath.row].getNameWithTitles() ?? StringHolder.none
        case .Supervisors: labelText = thesis?.supervisors?[indexPath.row].getNameWithTitles() ?? StringHolder.none
        case .Faculty: labelText = thesis?.faculty?.name ?? StringHolder.none
        }
        cell.plainLabel.text = labelText
        return cell
    }


}
