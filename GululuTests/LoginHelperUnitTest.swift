//
//  LoginHelperUnitTest.swift
//  Gululu
//
//  Created by Baker on 17/7/26.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class LoginHelperUnitTest: BaseNewTest {
    
    let testModel = LoginHelper.share
        
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_checkUserInputIsEmail() {
        XCTAssertTrue(testModel.checkUserInputIsEmail("17721@142222"))
        
        XCTAssertTrue(testModel.checkUserInputIsEmail("123@qq.com"))
        
        XCTAssertTrue(testModel.checkUserInputIsEmail("@"))
        
        XCTAssertFalse(testModel.checkUserInputIsEmail("17721142222"))
        
        XCTAssertFalse(testModel.checkUserInputIsEmail("17721142222"))
    }
    
    func testHandleCheckUserAccountDic_OK()  {
        let result = [
                        "status": "OK",
                        "available" : true,
                        "msg": "account is available"
            
                     ] as [String : Any]
        let resultInt = testModel.handleCheckUserAccountDic(result as NSDictionary)
        XCTAssertEqual(resultInt, 2)
    }
    
    func testHandleCheckUserAccountDic_Falied()  {
        let result = [
            "status": "OK",
            "available" : false,
            "msg": "account is available"
            
            ] as [String : Any]
        let resultInt = testModel.handleCheckUserAccountDic(result as NSDictionary)
        XCTAssertEqual(resultInt, 1)
    }
    
    func testHandleCheckUserAccountDic_Falied_1()  {
        let result = [:] as [String : Any]
        let resultInt = testModel.handleCheckUserAccountDic(result as NSDictionary)
        XCTAssertEqual(resultInt, 0)
    }
    
  
    func testSingUpUserPhone_success() {
        GUser.share.email = "12222222222"
        let result = [
            "status": "OK",
            "x_user_token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh",
            "token":"eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh0",
            "x_user_sn":"T16Q5NVE98IH",
            "user_id":1000
            ] as [String : Any]
        XCTAssertEqual(testModel.handleSignUpAndLoginDic(result as NSDictionary, password: "123467"), 1)
    }
    
    func testSingUpUserPhone_avtived() {
        GUser.share.email = "12222222222"
        let result = [
            "status": "OK",
            "x_user_token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh",
            "token":"eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh0",
            "x_user_sn":"T16Q5NVE98IH",
            "user_status":"UNACTIVATED",
            "user_id":1000
            ] as [String : Any]
        XCTAssertEqual(testModel.handleSignUpAndLoginDic(result as NSDictionary, password: "123467"), 2)
    }
    
    func testSingUpUserPhone_failed() {
        let result = [:] as [String : Any]
        XCTAssertEqual(testModel.handleSignUpAndLoginDic(result as NSDictionary, password: "123467"), 0)
    }
    
    func testSingUpUserPhone_failed_noStatus() {
        let result = [
            "status": "error",
            "x_user_token": "eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh",
            "token":"eyJhbGciOiJIUzI1NiIsImV4cCI6MTUwMjEwMTk3MCwiaWF0IjoxNTAxNDk3MTcwfQ.eyJjb25maXJtIjoyMDE4N30.ol5b_OeL3Fe7PE9lgz99YKUSQ1i1X3xjEt-xl-kvqh0",
            "x_user_sn":"T16Q5NVE98IH",
            "user_id":1000
            ] as [String : Any]
        XCTAssertEqual(testModel.handleSignUpAndLoginDic(result as NSDictionary, password: "123467"), 0)
    }
    
    
}
