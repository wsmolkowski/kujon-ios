//
//  RefreshingTableViewController.swift
//  Kujon
//
//  Created by Adam on 31.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit


class RefreshingTableViewController: UITableViewController  {

    private var providers : Array<RestApiManager> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = KujonRefreshControl()
        refreshControl?.backgroundColor = UIColor.kujonBlueColor()
        refreshControl?.attributedTitle = StringHolder.refresh.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 11)!, color: .white)
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
        for provider in providers{
            provider.reload()
        }
    }
    func reload(provider: RestApiManager){
        provider.reload()
    }

    func addToProvidersList(provider: RestApiManager){
        providers.append(provider)
    }

}
