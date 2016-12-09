//
//  ThesesTableViewController.swift
//  Kujon
//
//  Created by Adam on 06.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class ThesesTableViewController: UITableViewController, ThesisCellDelegate {

    var theses: [Thesis]?
    private let cellId = "ThesisCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringHolder.theses
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "ThesisCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.greyBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        theses = nil;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theses?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let thesis = theses?[indexPath.row]
        return ThesisCell.calculateCellHeightForThesis(thesis!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ThesisCell
        cell.thesis = theses?[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: ThesisCellDelegate

    func thesisCell(_ cell: ThesisCell, didTapFacultyWithId id: String) {
        let faculiteController = FacultieTableViewController(nibName: "FacultieTableViewController", bundle: Bundle.main)
        faculiteController.facultieId = id
        self.navigationController?.pushViewController(faculiteController, animated: true)
    }

    func thesisCell(_ cell: ThesisCell, didTapSupervisorWithId id: String) {
        let controller = TeacherDetailTableViewController(nibName: "TeacherDetailTableViewController", bundle: Bundle.main)
        controller.teacherId = id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func thesisCell(_ cell: ThesisCell, didTapAuthorWithId id: String) {
        let controller = StudentDetailsTableViewController(nibName: "StudentDetailsTableViewController", bundle: Bundle.main)
        controller.userId = id
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
