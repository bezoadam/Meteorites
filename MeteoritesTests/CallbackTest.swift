//
//  CallbackTest.swift
//  Meteorites
//
//  Created by Adam Bezák on 22.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import XCTest
@testable import Meteorites

class CallbackTest: XCTestCase {
    
    func testAsyncCalback() {
        let expect = expectation(description: "SomeService does stuff and runs the callback closure")
        Service.sharedInstance.fetchData(completion: { (meteorites) in
            XCTAssert(true)
            expect.fulfill()
        })
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
}
