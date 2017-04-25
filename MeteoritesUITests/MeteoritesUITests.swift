//
//  MeteoritesUITests.swift
//  MeteoritesUITests
//
//  Created by Adam Bezák on 24.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import XCTest

class MeteoritesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        XCUIApplication().launch()
        app = XCUIApplication()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTableCellsCount() {
        let table = app?.tables
        XCTAssertEqual(table?.cells.count, 7, "Rows equals on app start.")
    }
    
    func testCellExpanding() {
        let table = app?.tables
        table?.cells.element(boundBy: 0).buttons["expand"].tap()
        XCTAssertEqual(table?.cells.count, 8, "Rows count does not equal after expanding")
    }
    
    func testCellClick() {
        let cell = app.tables.cells.element(boundBy: 0)
        let cell_title = cell.staticTexts["nameLabel"].label
        cell.tap()
        
        XCTAssertTrue(app.staticTexts[cell_title].exists)
    }
    
    func testAnnotationClick() {
        let cell = app.tables.cells.element(boundBy: 0)
        let cell_title = cell.staticTexts["nameLabel"].label
        let cell_detailName = cell.staticTexts["detailNameLabel"].label
        let fullAnnotationName = cell_title + ", " + cell_detailName
        cell.tap()
        let annotation = app.maps.element.otherElements[cell_title]
//        annotation.tap()
        
        
        XCTAssertTrue(annotation.exists)
    }
}
