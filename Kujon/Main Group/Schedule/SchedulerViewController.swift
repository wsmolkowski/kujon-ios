//
//  SchedulerViewController.swift
//  Kujon
//
//  Created by Wojciech Maciejewski on 09/06/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController, NavigationDelegate, UITableViewDelegate, UITableViewDataSource {
    private let LectureCellId = "id_for_lecture"

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: NavigationMenuProtocol! = nil

    func setNavigationProtocol(delegate: NavigationMenuProtocol) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationMenuCreator.createNavMenuWithDrawerOpening(self, selector: #selector(SchedulerViewController.openDrawer))
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.registerNib(UINib(nibName: "LectureViewTableViewCell", bundle: nil), forCellReuseIdentifier: LectureCellId)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openDrawer() {
        delegate?.toggleLeftPanel()
    }


    @available(iOS 2.0, *)  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


    @available(iOS 2.0, *)  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: LectureViewTableViewCell = tableView.dequeueReusableCellWithIdentifier(LectureCellId, forIndexPath: indexPath) as! LectureViewTableViewCell
//        var usos = usosList[indexPath.row] as Usos
//        dispatch_async(dispatch_get_main_queue()) {
//
//            (cell as! UsosTableViewCell).imagePlace?.image = UIImage(data: NSData(contentsOfURL: NSURL(string:usos.image)!)!)
//            cell.setNeedsLayout()
//        }
//        (cell as! UsosTableViewCell).label.text = usos.name

        return cell
    }
}
