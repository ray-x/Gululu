//
//  GululuUITests.swift
//  GululuUITests
//
//  Created by Ray Xu on 20/04/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import XCTest
class GululuUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        let app = XCUIApplication()
        RegistrationTC1(app)
        
     }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func RegistrationTC1(_ app : XCUIApplication){
        
        let app = XCUIApplication()
        let nameField=app.textFields["Enter your email"]
        if nameField.exists
        {
            nameField.tap()
            let ramNumber = Int(arc4random_uniform(100000) + 1)
            let regMail="test_\(ramNumber)@test.cn"
            nameField.typeText(regMail)
            
            let passdBox=app.secureTextFields["Create a password"]
            passdBox.tap()
            let passd="121212"
            passdBox.typeText(passd)
            let signUpButton = app.buttons["Sign\r up"]
            signUpButton.tap()
        }else{
            //already registered
            //check main
        }
        
        sleep(2)
        while (!app.buttons["Let's\r go"].exists ) {sleep(1)}
        
        let goBut = app.buttons["Let's\r go"]
        goBut.tap()
        
        //add child proccess
        XCTAssertTrue(app.textFields["Child's name"].exists)
        if  app.textFields["Child's name"].exists
        {
            app.textFields["Child's name"].typeText("Hellboy\r")
            //app.typeText("name\r")
            app.buttons["girl close"].tap()
            app.buttons["Next"].tap()
            //photo selection broken in xcode 7.3
            //            app.buttons["Add Photo"].tap()
            //            if app.alerts["“Gululu” Would Like to Access Your Photos"].exists
            //            {
            //                app.alerts["“Gululu” Would Like to Access Your Photos"].collectionViews.buttons["OK"].tap()
            //            }
            //            app.tables.buttons["Moments"].tap()
            //            app.collectionViews["PhotosGridView"].childrenMatchingType(.Cell).elementBoundByIndex(2).tap()
            //            app.buttons["Choose"].tap()
            //
            //
            //            app.collectionViews["PhotosGridView"].childrenMatchingType(.Cell).elementBoundByIndex(2).tap()
            //            app.buttons["Choose"].tap()
            
        }
        app.buttons["Next"].tap()
        let datePickersQuery = app.datePickers
        datePickersQuery.pickerWheels["1"].tap()
        datePickersQuery.pickerWheels["1"].adjust(toPickerWheelValue: "21")
        datePickersQuery.pickerWheels["2010"].tap()
        datePickersQuery.pickerWheels["2010"].adjust(toPickerWheelValue: "1999")
        datePickersQuery.pickerWheels["June"].tap()
        datePickersQuery.pickerWheels["June"].adjust(toPickerWheelValue: "April")
        
        app.toolbars.buttons["Next"].tap()
        
        
        app.buttons["Next"].tap()
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        sleep(2)
        app.buttons["Next"].tap()
        sleep(1)
        let img=app.images["小忍小"]
        img.swipeLeft()
        app.buttons["Next"].tap()
        app.buttons["Yes"].tap()
        app.textFields["Password"].tap()
        app.textFields["Password"].typeText("aaaaaa")
        app.buttons["Next:"].tap()
        
        var nextButton = app.buttons["Next"]
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        //app.alerts["“Gululu” Would Like to Send You Notifications"].collectionViews.buttons["OK"].tap()
        sleep(18)
        nextButton = app.buttons["Next"]  //"Retry"
        nextButton.tap()

    }
    
    func testLoginSuccess() {
        
        let app = XCUIApplication()
        app.textFields["someone@mygululu.com"].tap()
        app.textFields["someone@mygululu.com"]
        app.typeText("\r")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"]
        app.typeText("\r")
        
        
    }


    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.buttons["buttonMyFriends"].tap()
        app.buttons["back"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Gululu.MainVC").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).images["Portrait"].tap()
        app.collectionViews.images["Portrait"].tap()
    
    
    }
    
}
