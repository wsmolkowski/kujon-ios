//
// Created by Wojciech Maciejewski on 14/06/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

import Foundation

class JsonDataLoader {

    static func loadJson(name: String) throws -> NSData! {
        let txtFilePath = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        return try NSData(contentsOfFile: txtFilePath!, options: .DataReadingMappedIfSafe)
    }
}
