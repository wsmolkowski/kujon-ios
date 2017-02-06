//
//  ShareOptions.swift
//  Kujon
//
//  Created by Adam on 19.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

struct ShareOptions {

    enum SharedWith: String {
        case all = "All"
        case none = "None"
        case list = "List"
    }

    let sharedWith: SharedWith?
    let sharedWithIds: [String]?

    init(sharedWith: SharedWith?, ids: [String]? = []) {
        self.sharedWith = sharedWith
        self.sharedWithIds = ids
    }
}
