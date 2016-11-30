//
//  KierunekDetailViewController.swift
//  Kujon
//
//  Created by Adam on 29.11.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit



class KierunekDetailViewController: UITableViewController {

    private enum SectionMap: Int {
        case header = 0
        case level
        case duration
        case id
        case mode
        case ectsUsedSum

        static func sectionForIndex(_ index:Int) -> SectionMap {
            if let section = SectionMap(rawValue: index) {
                return section
            }
            fatalError("Invalid section index")
        }
    }

    private let itemCellId: String = "itemCellId"
    private let itemCellHeight: CGFloat = 50.0
    private let itemHeaderHeight: CGFloat = 48.0
    private let headerCellId: String = "headerCellId"
    private let headerCellHeight: CGFloat = 110.0
    private let sectionsCount: Int = 6

    var programme: Programme?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.kierunekTitle
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()

        tableView.register(UINib(nibName: "GoFurtherViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: itemCellId)
        tableView.register(UINib(nibName: "KierunekHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellId)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)
        switch (section) {
        case .header: return nil
        case .level: return createLabelForSectionTitle(StringHolder.level)
        case .duration: return createLabelForSectionTitle(StringHolder.time_length)
        case .id: return createLabelForSectionTitle(StringHolder.identificator)
        case .mode: return createLabelForSectionTitle(StringHolder.tryb)
        case .ectsUsedSum: return createLabelForSectionTitle(StringHolder.ectsPoints)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .header ? headerCellForIndexPath(indexPath) : itemCellForIndexPath(indexPath)
    }

    private func headerCellForIndexPath(_ indexPath: IndexPath) -> KierunekHeaderCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! KierunekHeaderCell
        cell.kierunekLabel.text = programme?.name?.components(separatedBy:",").first
        return cell
    }

    private func itemCellForIndexPath(_ indexPath: IndexPath) -> GoFurtherViewCellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! GoFurtherViewCellTableViewCell
        let section = SectionMap.sectionForIndex(indexPath.section)
        let labelText: String?

        switch section {
        case .level: labelText = programme?.levelOfStudies
        case .duration: labelText = programme?.duration
        case .id: labelText = programme?.id
        case .mode: labelText = programme?.modeOfStudies
        case .ectsUsedSum: labelText = programme?.ectsUsedSum == nil ? nil : "\(programme!.ectsUsedSum!)"
        default: fatalError("Invalid indexpath")
        }

        cell.plainLabel.text = labelText ?? StringHolder.none
        cell.arrow.isHidden = true
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = SectionMap.sectionForIndex(section)
        return section == .header ? 0.0 : itemHeaderHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = SectionMap.sectionForIndex(indexPath.section)
        return section == .header ? headerCellHeight : itemCellHeight
    }


 }
