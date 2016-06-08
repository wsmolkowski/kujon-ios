//
//  KujonTests.swift
//  KujonTests
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright (c) 2016 Mobi. All rights reserved.
//

import XCTest
@testable import Kujon

class KujonTests: XCTestCase, UsosesProviderDelegate {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        loaded = false
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    var loaded = false
    func testUsosesProvider() throws {
        let provider = UsosesProvider()
        provider.delegate = self
        provider.loadUsoses()
        assert(loaded)

    }

    func onUsosesLoaded(arrayOfUsoses: Array<Usos>) {
        assert(arrayOfUsoses.count == 31)
        loaded = true
    }

    func onErrorOccurs() {
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
