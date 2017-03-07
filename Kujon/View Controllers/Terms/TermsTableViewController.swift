//
// Created by Wojciech Maciejewski on 12/07/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit


class TermsTableViewController: UITableViewController {


    private enum SectionMap: Int {
        case active = 0
        case inactive

        static func sectionForIndex(_ index:Int) -> SectionMap {
            if let section = SectionMap(rawValue: index) {
                return section
            }
            fatalError("Invalid section index")
        }
    }

    private let inactiveTermCellId = "InactiveTermCell"
    private let activeTermCellId = "ActiveTermCell"
    private let sectionsCount: Int = 2


    internal var terms: [Term] = []

    internal var activeTerms: [Term]  {
        return terms.filter { $0.active == true }
    }
    internal var inactiveTerms: [Term]  {
        return terms.filter { $0.active == false }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithBackButton(self, selector: #selector(TermsTableViewController.back),andTitle: StringHolder.terms)
        tableView.register(UINib(nibName: "InactiveTermCell", bundle: nil), forCellReuseIdentifier: inactiveTermCellId)
        tableView.register(UINib(nibName: "ActiveTermCell", bundle: nil), forCellReuseIdentifier: activeTermCellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

    }


    func setUpTerms(_ terms:Array<Term>){
        self.terms = terms
        self.tableView.reloadData()
    }

    func back(){
        let _ = self.navigationController?.popViewController(animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .active: return activeTerms.count
        case .inactive: return inactiveTerms.count
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = SectionMap.sectionForIndex(section)

        switch section {
        case .active: return createLabelForSectionTitle("Aktywne")
        case .inactive: return createLabelForSectionTitle("Nieaktywne")
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SectionMap.sectionForIndex(indexPath.section)
        switch section {
        case .active: return provideCellForActiveTerm(at: indexPath)
        case .inactive: return provideCellForInactiveTerm(at: indexPath)
        }

    }

    private func provideCellForActiveTerm(at indexPath: IndexPath) -> ActiveTermCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activeTermCellId, for: indexPath) as! ActiveTermCell
        let term = activeTerms[indexPath.row]
        cell.configureCell(with: term)
        return cell
    }

    private func provideCellForInactiveTerm(at indexPath: IndexPath) -> InactiveTermCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inactiveTermCellId, for: indexPath) as! InactiveTermCell
        let term = inactiveTerms[indexPath.row]
        cell.configureCell(with: term)
        return cell
    }

}
