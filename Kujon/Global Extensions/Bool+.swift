//
//  Bool+.swift
//  Kujon
//
//  Created by Adam on 03.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension Bool: StringConvertible {

    var toString: String {
        return self == true ? "true" : "false"
    }
    
}
