//
//  GSleepModelUT.swift
//  Gululu
//
//  Created by Baker on 17/5/15.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class GSleepModelUT: XCTestCase {
    
    let model = GSleepHelper.share
    
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
    
    func testBugGetLabelTimeStrValue() {
        let label = UILabel()
        label.text = ""
        XCTAssertEqual(model.getLabelTimeStrValue(label), "19:00")
        if Common.checkPreferredLanguagesIsEn(){
            label.text = "Bedtime:  21:00"
        }else{
            label.text = "睡眠時間:  21:00"
        }
        XCTAssertEqual(model.getLabelTimeStrValue(label), "21:00")
    }
    
    
    
}
