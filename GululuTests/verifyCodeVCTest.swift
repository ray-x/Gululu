//
//  verifyCodeVCTest.swift
//  Gululu
//
//  Created by Baker on 16/9/13.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu

class verifyCodeVCTest: BaseNewTest {
    
    let testModel = LoginHelper.share
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testHandlePhoneGetCodeResult_success() {
        let result = [
            "status": "OK",
            "msg": "send code success"
            ] as [String : Any]
        
        let resultInt = testModel.handlePhoneGetCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 1)
    }
    
    func testHandlePhoneGetCodeResult_failed_1() {
        let result = [
            "status": "OK",
            "msg": "send code error"
            ] as [String : Any]
        
        let resultInt = testModel.handlePhoneGetCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 4)
    }
    
    func testHandlePhoneGetCodeResult_failed_2() {
        let result = [:] as [String : Any]
        
        let resultInt = testModel.handlePhoneGetCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 0)
    }
    
    
    func testhandleCheckPhoneCodeResult_success() {
        let result = [
            "status": "OK",
            "msg": "verify ok"
            ] as [String : Any]
        
        let resultInt = testModel.handleCheckPhoneCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 1)
    }
    
    func testhandleCheckPhoneCodeResult_failed_1() {
        let result = [:] as [String : Any]
        
        let resultInt = testModel.handleCheckPhoneCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 0)
    }
    
    func testhandleCheckPhoneCodeResult_failed_2() {
        let result = [
            "status": "OK",
            "msg": "verify error"
            ] as [String : Any]
        
        let resultInt = testModel.handleCheckPhoneCodeResult(result as NSDictionary)
        XCTAssertEqual(resultInt, 2)
    }
    
    
}
