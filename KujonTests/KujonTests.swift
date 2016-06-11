//
//  KujonTests.swift
//  KujonTests
//
//  Created by Wojciech Maciejewski on 08/06/16.
//  Copyright (c) 2016 Mobi. All rights reserved.
//

import XCTest
@testable import Kujon

class KujonTests: XCTestCase, UsosesProviderDelegate
        , UserDetailsProviderDelegate
        , LectureProviderDelegate
        , GradesProviderDelegate {

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


    func testUserDetailsProvider() throws {
        let provider = UserDetailsProvider()
        provider.delegate = self
        provider.loadUserDetail()
        assert(loaded)

    }

    func onUserDetailLoaded(userDetails: UserDetail) {
        loaded = true
    }


    func testLectureProvider() throws {
        let provider = LectureProvider()
        provider.delegate = self
        provider.loadLectures("dwa tysiace sto dziewiecet")
        assert(loaded)

    }

    func onLectureLoaded(lectures: Array<Lecture>) {
        assert(lectures.count == 1)
        loaded = true
    }

    func testGradesProvider() {
        let provider = GradesProvider()
        provider.delegate = self
        provider.loadGrades()
        assert(loaded)

    }


    func onGradesLoaded(termGrades: Array<TermGrades>) {
//        assert(lectures.count == 1)
        loaded = true
    }

}
