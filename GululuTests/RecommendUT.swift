//
//  RecommendUT.swift
//  Gululu
//
//  Created by Baker on 17/8/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//
import XCTest
@testable import Gululu
class RecommendUT: BaseNewTest {
    
    let test_model = RecommendWaterHelper.share
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHandleResultFromNet() {
        let info1  = [ "info": "The story of Gululu Universe",
                       "rate": "0.7" ]
        let info2 = [  "info": "The story of Gululu Universe",
                       "rate": "0.6" ]
        let resultPost =  ["status": "OK", "recommend_water_rate" : [info1,info2]] as NSDictionary
        
        
        let remote_array = test_model.handleResult(resultPost as NSDictionary)
        
        XCTAssertEqual(remote_array.count, 2)

        XCTAssertEqual(test_model.rate_array.count, 2)
        
        let defaultArray = test_model.readDicFormDefault()
        
        XCTAssertEqual(defaultArray.count, 2)
    }
    
    func testIsNeedToUploadRate() {
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.2)
        test_model.currentRateInfo = RecommendRateInfo("", rate: 0.3)
        XCTAssertTrue(test_model.is_need_to_upload_rate())
        
    }
    
    func testIsNoNeedToUploadRate() {
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.2)
        test_model.currentRateInfo = RecommendRateInfo("", rate: 0.2)
        XCTAssertFalse(test_model.is_need_to_upload_rate())
        
    }
    
    func testGetDetailInfoFrom_rate() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        test_model.rate_array = [rate1, rate2, rate3, rate4, rate5, rate6]
        
        let info = test_model.getDetailInfoFrom_rate(0.3)
        XCTAssertEqual(info, "3")
        
        let info1 = test_model.getDetailInfoFrom_rate(0.35)
        XCTAssertEqual(info1, "")
    }
    
    func test_add_water_rate() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)

        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)

        test_model.choseRateInfo = rate1
        
        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate2.rate)
        
        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate3.rate)
        
        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate4.rate)
        
        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate5.rate)
        
        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate6.rate)
    }
    
    func test_add_water_rate_when_child_rate_not_in_list() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)
        
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.35)

        test_model.add_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate4.rate)
        
    }
    
    func test_cut_water_rate_when_child_rate_not_in_list() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)
        
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.35)
        
        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate3.rate)

    }
    
    func test_cut_water_rate() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)
        
        test_model.choseRateInfo = rate6

        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate5.rate)
        
        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate4.rate)
        
        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate3.rate)
        
        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate2.rate)
        
        test_model.cut_water_rate()
        XCTAssertEqual(test_model.choseRateInfo.rate, rate1.rate)
    }
    
    func test_checkCurrentRateInfoIsExistInList() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)

        test_model.currentRateInfo = RecommendRateInfo("", rate: 0.35)
        
        XCTAssertFalse(test_model.checkCurrentRateInfoIsExistInList())
        
        test_model.currentRateInfo.rate = 0.5
        
        XCTAssertTrue(test_model.checkCurrentRateInfoIsExistInList())

    }
    
    func test_checkAddButtonEnable() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.5)
        XCTAssertTrue(test_model.checkAddButtonEnable())
        test_model.choseRateInfo.rate = 0.6
        XCTAssertFalse(test_model.checkAddButtonEnable())
        
    }
    
    func test_checkCutButtonEnable() {
        let rate1 = RecommendRateInfo("1", rate: 0.1)
        let rate2 = RecommendRateInfo("2", rate: 0.2)
        let rate3 = RecommendRateInfo("3", rate: 0.3)
        let rate4 = RecommendRateInfo("4", rate: 0.4)
        let rate5 = RecommendRateInfo("5", rate: 0.5)
        let rate6 = RecommendRateInfo("6", rate: 0.6)
        
        let test_array = [rate6, rate2, rate4, rate3, rate5, rate1]
        test_model.rate_array = test_model.sortArray(test_array)
        test_model.choseRateInfo = RecommendRateInfo("", rate: 0.2)
        XCTAssertTrue(test_model.checkCutButtonEnable())
        test_model.choseRateInfo.rate = 0.1
        XCTAssertFalse(test_model.checkCutButtonEnable())
    }
    
    func test_countChildWeight() {
        GUser.share.activeChild = createObject(GChild.self)
        GUser.share.activeChild?.unit = "kg"
        GUser.share.activeChild?.weight = NSNumber(value: 23)
        saveContext()
        let result = test_model.countChildWeight()
        XCTAssertEqual(result, "25 kg")
    }
    
    func test_getBirthdayFormat() {
        XCTAssertEqual(test_model.getBirthdayFormat("1234567890"), "1234567890")
        XCTAssertEqual(test_model.getBirthdayFormat("1234567890111"), "1234567890")
        XCTAssertEqual(test_model.getBirthdayFormat("1234567890222"), "1234567890")
        XCTAssertEqual(test_model.getBirthdayFormat(nil), "")
        XCTAssertEqual(test_model.getBirthdayFormat(""), "")
        XCTAssertEqual(test_model.getBirthdayFormat("1234567890"), "1234567890")
    }
    
    
}
