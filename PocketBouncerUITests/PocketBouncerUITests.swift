//
//  PocketBouncerUITests.swift
//  PocketBouncerUITests
//
//  Created by Zach Crystal on 2017-06-22.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import XCTest

class PocketBouncerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        
        snapshot("Launch")
        app.buttons["Play Free Mode"].tap()
        
        let denyButton = app.buttons["deny"]
        snapshot("Game")
        denyButton.tap()

        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
