//
//  AsyncOperation.swift
//  Kujon
//
//  Created by Adam on 19.12.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class AsyncOperation: Operation {

    internal enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
        case cancelled = "isCancelled"

    }

    internal var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    override internal var isAsynchronous: Bool {
        return true
    }

    override internal var isReady: Bool {
        return super.isReady && state == .ready
    }

    override internal var isExecuting: Bool {
        return state == .executing
    }

    override internal var isFinished: Bool {
        return state == .finished || state == .cancelled
    }

    override internal var isCancelled: Bool {
        return state == .cancelled
    }

    override internal func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }

    override internal func cancel() {
        state = .cancelled
    }
}
