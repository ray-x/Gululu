//
//  NetWorkTest.swift
//  Gululu
//
//  Created by Baker on 17/2/8.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class NetWorkTest: XCTestCase {

    override func setUp() {
        super.setUp()
        BaseObject.share.cloudObject = MockCloudCommon.mockShareObject
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNetWork500() {
        MockCloudCommon.mockShareObject.resultPost = ["status": "Error", "status_code": 500, "msg": ""]
        MockCloudCommon.mockShareObject.createRESTRequest("checkEmail", body: nil, callback: { result in
            if result.boolValue {
                let dic : NSDictionary = result.value!
                XCTAssertEqual(dic["status_code"] as? Int, 500)
            }
        })
    }
    
    func testNetWork400() {
        MockCloudCommon.mockShareObject.resultPost = ["status": "Error", "status_code": 400, "msg": ""]
        MockCloudCommon.mockShareObject.createRESTRequest("checkEmail", body: nil, callback: { result in
            if result.boolValue {
                let dic : NSDictionary = result.value!
                XCTAssertEqual(dic["status_code"] as? Int, 400)
            }
        })
    }
    
    func testNetWork404() {
        MockCloudCommon.mockShareObject.resultPost = ["status": "Error", "status_code": 404, "msg": ""]
        MockCloudCommon.mockShareObject.createRESTRequest("checkEmail", body: nil, callback: { result in
            if result.boolValue {
                let dic : NSDictionary = result.value!
                XCTAssertEqual(dic["status_code"] as? Int, 404)
            }
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
