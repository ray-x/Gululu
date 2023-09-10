//
//  schoolTimeTest.swift
//  Gululu
//
//  Created by Baker on 17/6/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class schoolTimeTest: XCTestCase {
    
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
    
    func testFillinSchoolDict() {
        let schoolTime : SchoolTime =  createObject(SchoolTime.self)!
        schoolTime.childID = "11111"

        let result = schoolTime.fillinSchoolDict()
        print(result)
    }
    
    func testFillinSleepTimeDict() {
        let sleep : WakeSleep = createObject(WakeSleep.self)!
        sleep.childID = "11111"
        let result = sleep.fillinSleepTimeDict()
        print(result)
    }
    
}