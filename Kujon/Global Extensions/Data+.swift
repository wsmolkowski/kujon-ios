//
//  Data+.swift
//  Kujon
//
//  Created by Adam on 31.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension Data {

    internal mutating func append(string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }

}
