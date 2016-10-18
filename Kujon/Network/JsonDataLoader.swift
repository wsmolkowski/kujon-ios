//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class JsonDataLoader {

    static func loadJson(_ name: String) throws -> Data! {
        let txtFilePath = Bundle.main.path(forResource: name, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: txtFilePath!), options: .mappedIfSafe)
    }
}
