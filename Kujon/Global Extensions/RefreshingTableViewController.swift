//
//  RefreshingTableViewController.swift
//  Kujon
//
//  Created by Adam on 31.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class RefreshingTableViewController: UITableViewController  {

    override func viewDidLoad() {
        refreshControl = KujonRefreshControl()
        refreshControl?.backgroundColor = UIColor.kujonBlueColor()
        refreshControl?.attributedTitle = NSAttributedString(string: StringHolder.refresh)
        refreshControl?.addTarget(self, action: #selector(RefreshingTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isBeingPresented || self.isMovingToParentViewController {
            (refreshControl as? KujonRefreshControl)?.beginRefreshingProgrammatically()
        }
    }

    func refresh(_ refreshControl: KujonRefreshControl) {
        if refreshControl.refreshType == .userInitiated {
            clearCachedResponse()
        }
        loadData()
    }

    func loadData() {
        fatalError("loadData method should be overridden")
    }

    func clearCachedResponse() {
        // method can be overridden
    }

}
