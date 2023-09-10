//
//  loginVCTest.swift
//  Gululu
//
//  Created by Ray Xu on 12/09/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class loginVCTest: BaseTest {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginWithMail() {
        
        GUser.share.email = "baker.cheng@qq.com"
        MockCloudCommon.mockShareObject.resultPost = ["available" : 0, "email" : "baker.cheng@qq.com", "msg" : "email has been registered", "status" : 1] as NSDictionary
        GUser.share.checkUserEmailAviable("baker.cheng@qq.com", { result in
             XCTAssertEqual(result, 1)
        })

    }
    
    func testLoginSelf() {
        GUser.share.email = "baker.cheng@qq.com"
        MockCloudCommon.mockShareObject.resultPost = ["token" : "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ4Njk2NzcxOSwiaWF0IjoxNDg2MzYyOTE5fQ.eyJjb25maXJtIjoyNjAyfQ.Pp1kyHDr8MgJuhwgolve9DUOkOdEpmI6GAQrjBR8a_g", "user_id" : 2602, "x_user_sn" : "74R3PNVU5JQ8", "status" : 1, "x_user_token" : "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ4Njk2NzcxOSwiaWF0IjoxNDg2MzYyOTE5fQ.eyJjb25maXJtIjoyNjAyfQ.Pp1kyHDr8MgJuhwgolve9DUOkOdEpmI6GAQrjBR8a_g"] as NSDictionary
        GUser.share.login("123456", cloudCallback: { result in
            XCTAssertEqual(result, true)
        })

    }
    
    func testSignUpSelf(){
        MockCloudCommon.mockShareObject.resultPost = ["token" : "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ4Njk2NzcxOSwiaWF0IjoxNDg2MzYyOTE5fQ.eyJjb25maXJtIjoyNjAyfQ.Pp1kyHDr8MgJuhwgolve9DUOkOdEpmI6GAQrjBR8a_g", "user_id" : 2602, "x_user_sn" : "74R3PNVU5JQ8", "status" : 1, "x_user_token" : "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ4Njk2NzcxOSwiaWF0IjoxNDg2MzYyOTE5fQ.eyJjb25maXJtIjoyNjAyfQ.Pp1kyHDr8MgJuhwgolve9DUOkOdEpmI6GAQrjBR8a_g"] as NSDictionary
        GUser.share.singUp("123456", cloudCallback: { result in
            XCTAssertEqual(result, true)
        })
    }
    
    func testResetPassword() {
        GUser.share.email = "baker.cheng@qq.com"
        GUser.share.password = "123456"
        GUser.share.verification_key = "1111"
         MockCloudCommon.mockShareObject.resultPost = ["status" : 1] as NSDictionary
        GUser.share.resertPassword("123456", cloudCallback: { result in
            XCTAssertEqual(result, false)
        })
    }
    
    func testGetChildList() {
        let child1 : NSDictionary = [ "birthday": "2010-06-01 00:00:00",
                                      "control_type" : "CONTROLLER",
                                      "created_date" : "2016-12-26 08:08:09",
                                      "gender" : "boy",
                                      "has_cup" : 1,
                                      "has_pet" : 1,
                                      "nickname" : "dd",
                                      "recommend_water" : 960,
                                      "unit" : "kg",
                                      "weight" : 25,
                                      "weight_lbs" : 55,
                                      "x_child_sn" : "9350IGECS2XH"]
        let child2 : NSDictionary = [ "birthday": "2010-08-02 00:00:00",
                                      "control_type" : "CONTROLLER",
                                      "created_date" : "2017-01-09 06:37:55",
                                      "gender" : "girl",
                                      "has_cup" : 0,
                                      "has_pet" : 1,
                                      "nickname" : "baker1",
                                      "recommend_water" : 600,
                                      "unit" : "lbs",
                                      "weight" : 10,
                                      "weight_lbs" : 23,
                                      "x_child_sn" : "6GYAQVN712ZP"]
        let child3 : NSDictionary = ["birthday": "2010-06-03 00:00:00",
                                     "control_type" : "CONTROLLER",
                                     "created_date" : "2017-01-11 07:21:16",
                                     "gender" : "boy",
                                     "has_cup" : 0,
                                     "has_pet" : 1,
                                     "nickname" : "fasdf",
                                     "recommend_water" : 940,
                                     "unit" : "kg",
                                     "weight" : 24,
                                     "weight_lbs" : 52,
                                     "x_child_sn" : "TJN5DEK9Z7MB"]
        let child4 : NSDictionary = ["birthday": "2010-06-03 00:00:00",
                                     "control_type" : "CONTROLLER",
                                     "created_date" : "2017-01-11 07:21:16",
                                     "gender" : "boy",
                                     "has_cup" : 0,
                                     "has_pet" : 1,
                                     "nickname" : "33333",
                                     "recommend_water" : 940,
                                     "unit" : "kg",
                                     "weight" : 24,
                                     "weight_lbs" : 52,
                                     "x_child_sn" : "TJN5DEK9Z7MV"]
        
        let childArray : NSArray = [child1,child2,child3,child4]
        MockCloudCommon.mockShareObject.resultPost = ["children" :
            childArray,
                                          "status" : 1 ]
        GChild.share.getChildList({ _ in
            let fetchedChild:[Children]? = createObjects(Children.self) as? [Children]
            XCTAssertEqual(fetchedChild?.count, 4)
        })
        
    }

    
    override func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
