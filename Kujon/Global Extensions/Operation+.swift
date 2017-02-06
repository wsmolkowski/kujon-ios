//
//  Operation+.swift
//  Kujon
//
//  Created by Adam on 20.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation

extension Operation {

    @discardableResult
    public func dependsOn( _ operation:Operation) -> Operation {
        self.addDependency(operation)
        return operation
    }
    
}
