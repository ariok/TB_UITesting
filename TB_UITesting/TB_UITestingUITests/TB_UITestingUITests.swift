//
//  TB_UITestingUITests.swift
//  TB_UITestingUITests
//
//  Created by Yari D'areglia on 14/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import XCTest

class TB_UITestingUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING_MODE"]
        app.launch()
    
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_login_when_credentials_are_not_valid(){
       
        let app = XCUIApplication()
        performLogin(app, username:"invalid_username")
        
        XCTAssert(app.buttons["signin"].exists)
    }
    
    func test_login_when_credentials_are_valid(){
        
        let app = XCUIApplication()
        performLogin(app, username:"user_with_robots")

        XCTAssert(!app.buttons["signin"].exists)
    }
    
    func test_robotlist_when_robot_are_available(){
        
        let app = XCUIApplication()
        performLogin(app, username:"user_with_robots")
        
        XCTAssertEqual(app.tables.cells.count, 2, "Expected 2 cells")
    }
    
    func test_robotlist_when_robot_are_not_available(){
        
        let app = XCUIApplication()
        performLogin(app, username:"user_without_robots")
        
        XCTAssertEqual(app.tables.cells.count, 0, "Expected 0 cells")
    }
    
    func test_robotdetail(){
        
        let app = XCUIApplication()
        performLogin(app, username:"user_with_robots")
        
        app.tables.staticTexts["Eve"].tap()
        XCTAssert(app.staticTexts["r1"].exists)
        XCTAssert(app.staticTexts["Eve"].exists)
        XCTAssertEqual(app.progressIndicators["charge"].value as? String, "10%")

        app.navigationBars["Eve"].buttons["Robots"].tap()
    
        app.tables.staticTexts["Jarvis"].tap()

        XCTAssert(app.staticTexts["r2"].exists)
        XCTAssert(app.staticTexts["Jarvis"].exists)
        XCTAssertEqual(app.progressIndicators["charge"].value as? String, "95%")
    }
    
    
    func test_logout(){
        
        let app = XCUIApplication()
        performLogin(app, username:"user_with_robots")
        
        app.navigationBars["Robots"].buttons["Logout"].tap()
        XCTAssert(app.buttons["signin"].exists)
    }
    
    func performLogin(app:XCUIApplication, username:String){
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(username)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("mypassword")
        app.buttons["signin"].tap()
    }
    
}
