//
//  GCupUnitTest.swift
//  Gululu
//
//  Created by Baker on 17/3/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class GCupUnitTest: BaseTest {
    let model = GCup.share
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetCupGame_version() {
        MockCloudCommon.mockShareObject.resultPost = [  "status" : 1,"game_version" : "game_ep1_backhome"]
    }
    
    func test_handle_child_pet_cup_level_result() {
        let levelDic = ["status": "OK",
                        "cup_level" : 37
            ] as [String : Any]
        let result_int = model.handle_child_pet_cup_level_result(levelDic as NSDictionary)
        XCTAssertEqual(result_int, 37)
    }
    
    func test_handle_child_pet_cup_level_result1() {
        let levelDic = ["status": "OK",
                        "cup_level" : 0
            ] as [String : Any]
        let result_int = model.handle_child_pet_cup_level_result(levelDic as NSDictionary)
        XCTAssertEqual(result_int, 0)
    }
    
    func test_handle_child_pet_cup_level_result2() {
        let result_int = model.handle_child_pet_cup_level_result(nil)
        XCTAssertEqual(result_int, -1)
    }
    
    func test_handle_child_pet_cup_level_result3() {
        let levelDic = ["status": "OK",
                        "cup_level" : -1
            ] as [String : Any]
        let result_int = model.handle_child_pet_cup_level_result(levelDic as NSDictionary)
        XCTAssertEqual(result_int, -1)
    }
    
    func test_save_child_pet_cup_level() {
        let levelDic = ["status": "OK",
                        "cup_level" : 10
            ] as [String : Any]
        model.save_child_pet_cup_level(levelDic as NSDictionary)
        
        let resultInt = model.read_child_pet_cup_level()
        XCTAssertEqual(10, resultInt)
        
        model.remove_child_pet_cup_level()
        
        let resultIntd = model.read_child_pet_cup_level()
        XCTAssertEqual(-1, resultIntd)

    }

}
