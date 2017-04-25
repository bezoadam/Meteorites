//
//  MeteoritesTests.swift
//  MeteoritesTests
//
//  Created by Adam Bezák on 23.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import XCTest
@testable import Meteorites

class MeteoritesTests: XCTestCase {
    
    var vc: ViewController! = ViewController()
    var meteorites: [Meteor?]? = [Meteor]()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        
        let except = expectation(description: "Download should succeed")
        
        vc.fetchMeteorites(completion: { (err) in
            if err == nil {
                except.fulfill()
            }
        })
        waitForExpectations(timeout: 10) { (err) in
            XCTAssertNil(err, "Test timed out! \(String(describing: err?.localizedDescription))")
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test1DownloadWithExceptation() {
        
        
        
    }
    
    func test2Date() {
        
        let m = vc.getMeteorites()

//        Meteorites.Service.sharedInstance.fetchData(completion: { (meteorites, err) in
//            if err == nil {
//                self.meteorites = meteorites
//            }
//        })
//        
//        for m in meteorites! {
//            print(m.date)
//        }
    }
}