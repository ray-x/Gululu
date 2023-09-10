//
//  RegisterUnitTest.swift
//  Gululu
//
//  Created by Baker on 16/7/14.
//  Copyright © 2016年 w19787. All rights reserved.
//

import XCTest
@testable import Gululu
class RegisterUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testNumberAddAdd() -> Void {
        for var i : Int in 0...10 {
            print("add berofr",i)
            if i < 5 {
                i = i+1
                print("add after",i)
                print("this big than 5")
            }
            print("add after teen",i)
        }
    }
    
}
