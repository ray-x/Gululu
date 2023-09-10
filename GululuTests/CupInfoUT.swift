//
//  CupInfoUT.swift
//  Gululu
//
//  Created by Baker on 17/5/11.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class CupInfoUT: BaseNewTest {
    
    let model = CupInfoHelper.share
        
    override func setUp() {
        super.setUp()
        activeChildID = "QQQQQ"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCupinfo1min() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 57 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)
        XCTAssertEqual(model.syncTime, "1 " + Localizaed("min"))
        XCTAssertTrue(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo1min1() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 110 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "1 " + Localizaed("min"))
        XCTAssertTrue(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo2mins() {
        
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 120 - 28800
        let result = [  "cup_connect_overtime": 3600,
                          
                          "last_sync_time": syncTime,
                          
                          "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "2 " + Localizaed("mins"))
        XCTAssertTrue(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo1hr() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*2 + 1 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "1 " + Localizaed("hr"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo1hr1() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600 - 12 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "1 " + Localizaed("hr"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo2hrs() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*2 - 12 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "2 " + Localizaed("hrs"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo1day() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24 - 1200 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "1 " + Localizaed("day"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo1day1() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24*2 + 1 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "1 " + Localizaed("day"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo2days() {
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24*2 - 1200 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "2 " + Localizaed("days"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo3days() {
        model.saveClickRedSign(false)
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24*3 - 120 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "3 " + Localizaed("days"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo4daysWhenClick() {
        model.saveClickRedSign(true)
        
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24*4 - 120 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)

        XCTAssertEqual(model.syncTime, "4 " + Localizaed("days"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    func testGetCupinfo4daysWhenNoClick() {
        model.saveClickRedSign(false)
        
        let date = Date()
        let nowTimer = date.timeIntervalSince1970
        let syncTime = Int(nowTimer) - 3600*24*4 - 120 - 28800
        let result = [  "cup_connect_overtime": 3600,
                        
                        "last_sync_time": syncTime,
                        
                        "status": "OK"] as [String : Any]
        
        model.handleDicFormNet(result as NSDictionary?)
        
        XCTAssertEqual(model.syncTime, "4 " + Localizaed("days"))
        XCTAssertFalse(model.cupConnectStatus)
        XCTAssertTrue(model.cupConnectTimeLastThreeDays)
    }
    
    func testUser4DayslaterAndGetDataAnd4DaysLater() {
        testGetCupinfo2mins()

        XCTAssertFalse(model.readClickRedSgin())
        testGetCupinfo4daysWhenClick()
        XCTAssertTrue(model.readClickRedSgin())
        model.saveClickRedSign(true)
        XCTAssertTrue(model.readClickRedSgin())
        XCTAssertFalse(model.cupConnectTimeLastThreeDays)
    }
    
    
}
