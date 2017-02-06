//
//  UIDevice+.swift
//  Kujon
//
//  Created by Adam on 15.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension UIDevice {

    static func freeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                return nil
        }
        return freeSize.int64Value
    }

}
