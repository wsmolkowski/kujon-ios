//
//  KujonRefreshControl.swift
//  Kujon
//
//  Created by Adam on 31.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit

class KujonRefreshControl: UIRefreshControl {

    enum RefreshType {
        case programmatic
        case userInitiated
    }

    var refreshType: RefreshType = .userInitiated

    func beginRefreshingManually() {
        refreshType = .programmatic
        if let scrollView = superview as? UIScrollView {
            print("PROGRAMMATIC REFRESH")
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height * 1.2), animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: { [unowned self] in
                self.sendActions(for: .valueChanged)
                self.beginRefreshing()
            })
        }
    }

    override func endRefreshing() {
        super.endRefreshing()
        refreshType = .userInitiated
    }

}
