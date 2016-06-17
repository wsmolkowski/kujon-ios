//
// Created by Wojciech Maciejewski on 17/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class NSlogManager {

    static func showLog(text: String) {

        #if DEBUG
            NSLog(text)
        #endif
    }
}
