//
//  KujonTests.swift
//  KujonTests
//
//  Created by Adam on 14.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

import XCTest

class KujonTests: XCTestCase,MessageProviderDelegate {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMessage() {
        let provider = MessageProvider()
        provider.delegate = true
        provider.test = true
        provider.loadMessage()
        assert(self.messages.count == 1)
    }
    var messages:Array<Message> = Array()
    func onMessageLoaded(_ message: Array<Message>) {
        self.messages = message
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
