//
//  GChildUT.swift
//  Gululu
//
//  Created by Baker on 17/4/5.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class GChildUT: BaseTest {
    
    let model = GChild.share
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testupdateActiveChildInfo() {
        activeChildID = "ddd"
        model.updateActiveChildInfo({ result in
            XCTAssertEqual(result.boolValue, false)
        })
    }
    
    func test_getActiveChildRecommentWater() {
        let result = model.getActiveChildRecommentWater("kg")
        XCTAssertEqual(0, result)
    }
    
    func test_getActiveChildRecommentWater_nil() {
        GUser.share.activeChild = createObject(Children.self)

        let result = model.getActiveChildRecommentWater(nil)
        XCTAssertEqual(0, result)
    }
    
    func test_getActiveChildRecommentWater_1888() {
        GUser.share.activeChild = createObject(Children.self)
        GUser.share.activeChild?.recommendWater = 1888
        GUser.share.activeChild?.water_rate = 1.0
        
        let result = model.getActiveChildRecommentWater("kg")
        XCTAssertEqual(1890, result)
    }
    
    func test_changeRecommendWater() {
        let result = model.changeRecommendWater(nil,unitStr: nil)
        XCTAssertEqual(result, 0)
        let result1 = model.changeRecommendWater(960,unitStr: "lbs")
        XCTAssertEqual(result1, 32)
        let result2 = model.changeRecommendWater(960,unitStr: "kg")
        XCTAssertEqual(result2, 960)
    }
    
    func test_handleHourDayToPer() {
        GUser.share.activeChild = createObject(Children.self)
        GUser.share.activeChild?.unit = "kg"
    }
    
    func test_getMainViewUnitStr() {
//        let restult = model.getMainViewUnitStr(100)
//        print(restult)
    }
    
    func test_getActiveChildBaseRecommentWater()  {
        XCTAssertEqual(model.getActiveChildBaseRecommentWater(), Int(model.defaultRecommendValue))
        
    }
    
    func test_getChildUnitDayStr() {
        GUser.share.activeChild = createObject(Children.self)
        GUser.share.activeChild?.unit = "lbs"
        XCTAssertEqual(model.getChildUnitDayStr(), Localizaed("oz/day"))
    }
    
    func test_getChildUnitDayStr_1() {
        GUser.share.activeChild?.unit = "kg"
        XCTAssertEqual(model.getChildUnitDayStr(), Localizaed("ml/day"))
    }
    
    func test_isHaveChild()  {
        XCTAssertFalse(model.isHaveChild())
        
        let child: Children = createObject(Children.self)!
        child.childID = "test_child_id"
        backgroundMoc?.insert(child)
        XCTAssertTrue(model.isHaveChild())
    }
    
    
        
}
