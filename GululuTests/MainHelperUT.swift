//
//  MainHelperUT.swift
//  GululuTests
//
//  Created by baker on 2018/2/2.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class MainHelperUT: XCTestCase {
    
    let test_model = MianVCHepler.share
    
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
    
    func test_setLockedTimeInSetting()  {
        // china language
//        test_model.setLockedTimeInSetting()
//        XCTAssertNotNil(test_model.lockedTime)
//        XCTAssertEqual(test_model.lockedTime, 1800)
    }
    
}
