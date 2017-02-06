//
//  Tranferable
//  Kujon
//
//  Created by Adam on 21.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation


protocol Transferable: class {

    var delegate: TransferDelegate? { get set }
    var operations: [Operation] { get set }

    func createOperations() -> [Operation]
    func cancel()
}


protocol TransferDelegate: class {

    func transfer( _ transfer: Transferable?, didProceedWithProgress progress: Float, bytesProceededPerOperation bytesProceeded: String, totalSize: String)

    func transfer( _ transfer: Transferable?, didFinishWithSuccessAndReturn file: Any?)

    func transfer( _ transfer: Transferable?, didFailExecuting operation: Operation?, errorMessage:String)

    func transfer( _ transfer: Transferable?, didCancelExecuting operation: Operation?)
}
