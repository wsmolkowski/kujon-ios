//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation
import UIKit

class IntrinsicTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }


    override func intrinsicContentSize() -> CGSize {
        self.layoutIfNeeded()
        return CGSizeMake(UIViewNoIntrinsicMetric, contentSize.height)
    }

}