//
//  ParentLockViewTest.swift
//  GululuTests
//
//  Created by baker on 2018/6/13.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class ParentLockViewTest: XCTestCase {
    
    var paraLockView =  ParentLockView()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func test_checkInputStringValied() {
        XCTAssertFalse(paraLockView.checkInputStringValied("1900"))
        XCTAssertFalse(paraLockView.checkInputStringValied("2005"))
        XCTAssertFalse(paraLockView.checkInputStringValied("2011"))
        
        XCTAssertTrue(paraLockView.checkInputStringValied("2001"))
        XCTAssertTrue(paraLockView.checkInputStringValied("1920"))
        XCTAssertTrue(paraLockView.checkInputStringValied("2004"))

    }
    
    
    
}
