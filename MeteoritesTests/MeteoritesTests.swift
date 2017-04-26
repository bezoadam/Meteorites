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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vc = nil
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
    
    
    func testIfDataIsDownloaded() {
        let m = vc.getMeteorites()
        XCTAssertNotNil(m)
    }
    
    func testIf1MeteorIsValid() {
        let m = vc.getMeteorites()
        
        for meteor in m {
            XCTAssertNotNil(meteor?.name, "Meteor name does not exist")
            XCTAssertNotNil(meteor?.mass, "Meteor mass does not exist")
            XCTAssertNotNil(meteor?.date, "Meteor date does not exist")
        }
    }
    
    func testIfDateIsValid() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let ref_date = dateFormatter.date(from: "2011-01-01T00:00:00.000")
        
        let m = vc.getMeteorites()
        
        for meteor in m {
            if ref_date! > (meteor?.date)! {
                XCTFail("There is wrong date in fetched data")
            }
        }
    }
    
    func testIfSorted() {
        let m = vc.getMeteorites()
        
        for i in 0 ..< m.count {
            if i + 1 == m.count {
                return
            }
            XCTAssertGreaterThan((m[i]?.mass)!, (m[i + 1]?.mass)!, "Meteorites are not sorted.")
        }
    }

}
