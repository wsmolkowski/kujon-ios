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

    override init() {
        super.init()
        attributedTitle = StringHolder.refresh.toAttributedStringWithFont(UIFont.kjnFontLatoRegular(size: 11)!, color: .white)
        tintColor = .white
        backgroundColor = UIColor.kujonBlueColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginRefreshingProgrammatically() {
        refreshType = .programmatic
        if let scrollView = superview as? UIScrollView {
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
