//
//  Protocols.swift
//  Kujon
//
//  Created by Adam on 02.01.2017.
//  Copyright © 2017 Mobi. All rights reserved.
//

import Foundation

protocol CallbackOperation {

    var delegate: OperationDelegate? { get set }
}


protocol OperationDelegate: class {

    func operationWillStartReportingProgress( _ operation: Operation?)

    func operationWillStopReportingProgress( _ operation: Operation?)

    func operation( _ operation: Operation?, didProceedWithProgress progress:Float, bytesProceeded:String, totalSize:String)

    func operation( _ operation: Operation?, didFailWithErrorMessage message: String)

    func operationDidCancel(operation: Operation?)
}
