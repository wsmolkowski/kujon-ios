//
//  DispatchQueue+.swift
//  Kujon
//
//  Created by Adam on 23.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension DispatchQueue {

    func asyncAfter(seconds delay: Double, closure: @escaping () -> ()) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure)
    }
    
}
