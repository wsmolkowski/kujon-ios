//
//  CellPositionType.swift
//  Kujon
//
//  Created by Adam on 21.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

internal enum CellPositionType {
    case top
    case middle
    case bottom
    case topAndBottom

    internal static func cellPositionTypeForIndex(_ index: Int, in list: [AnyObject]) -> CellPositionType {

        if list.count == 1 {
            return .topAndBottom
        }

        switch index {
        case list.startIndex:
            return .top
        case list.endIndex - 1:
            return .bottom
        default:
            return .middle
        }
    }
}
