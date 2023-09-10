//
//  AppDataUT.swift
//  Gululu
//
//  Created by Baker on 17/4/12.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class AppDataUT: XCTestCase {
    
    let model = AppData.share
    
    override func setUp() {
        super.setUp()
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
    
    func testgetAppInstallFirstTime() {
        let result = model.getAppInstallFirstTime()
        XCTAssertNotNil(result)
    }
    
    func testCheskupIosVersionIs10() {
        let ret1: Bool = model.cheskupIosVersionIs10("10.0.0")
        XCTAssertTrue(ret1)
        
        let ret2: Bool = model.cheskupIosVersionIs10("10.0.10")
        XCTAssertTrue(ret2)
        
        let ret3: Bool = model.cheskupIosVersionIs10("10.10.0")
        XCTAssertTrue(ret3)
        
        let ret4: Bool = model.cheskupIosVersionIs10("10.10.10")
        XCTAssertTrue(ret4)
    }
    
    func testCheskupIosVersionNot10() {
        let ret1: Bool = model.cheskupIosVersionIs10("9.9.9")
        XCTAssertFalse(ret1)
        
        let ret2: Bool = model.cheskupIosVersionIs10("8.0.0")
        XCTAssertFalse(ret2)
        
        let ret3: Bool = model.cheskupIosVersionIs10("7.7.0")
        XCTAssertFalse(ret3)
        
        let ret4: Bool = model.cheskupIosVersionIs10("6.0.0")
        XCTAssertFalse(ret4)
    }
    
    func testAppFistInstallTimeNotNil() {
        XCTAssertNotNil(model.getAppInstallFirstTime())
    }
    
    func tests_save_key_chain()  {
       _ = model.getUUID_from_keyChain()
    }
    
}
