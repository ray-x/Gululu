//
//  DeviceInfoUT.swift
//  Gululu
//
//  Created by Baker on 17/4/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class DeviceInfoUT: BaseNewTest {
    
    let model = DeviceInfoHelper.share
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetDeviceInfo() {
        let version1 = [  "package_name": "Firmware",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        let version2 = [  "package_name": "Game",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        let version3 = [  "package_name": "Network",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        
        let result = [version1,version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 3)
        XCTAssertEqual(false, self.model.isShouldShowNewIcon())
        
    }
    
    func testGet2DeviceInfo() {

        let version2 = [  "package_name": "Game",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        let version3 = [  "package_name": "Network",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        
        let result = [version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 3)
        XCTAssertEqual(false, self.model.isShouldShowNewIcon())
        
    }
    
    func testnoNeedShowNewIcon() {
        let version1 = [  "package_name": "main_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.47"] as [String : Any]
        let version2 = [  "package_name": "PET1",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        let version3 = [  "package_name": "wifi_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        
        let result = [version1,version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 6)
        XCTAssertEqual(true, self.model.isShouldShowNewIcon())
        
    }
     
    func testneedShowNewIcon() {
        let version1 = [  "package_name": "main_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.47"] as [String : Any]
        let version2 = [  "package_name": "PET1",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.6.46"] as [String : Any]
        let version3 = [  "package_name": "wifi_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        
        let result = [version1,version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 6)
        XCTAssertEqual(true, self.model.isShouldShowNewIcon())
        
    }
    
    func testisFirstNewVersionAtPostion() {
        let version1 = [  "package_name": "main_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.47"] as [String : Any]
        let version2 = [  "package_name": "PET1",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.6.46"] as [String : Any]
        let version3 = [  "package_name": "wifi_fw",
                          
                          "current_version": "1.3.46",
                          
                          "latest_version": "1.3.46"] as [String : Any]
        
        let result = [version1,version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 6)
        XCTAssertEqual(3, self.model.isFirstNewVersionAtPostion())
    }
    
    func testisbugNewVersionAtPostion() {
        let version1 = [  "package_name": "Firmware",
                          
                          "current_version": "1.3.47",
                          
                          "latest_version": "1.3.48"] as [String : Any]
        let version2 = [  "package_name": "Game",
                          
                          "current_version": "2.0.40",
                          
                          "latest_version": "2.0.42"] as [String : Any]
        let version3 = [  "package_name": "Network",
                          
                          "current_version": "1.3.25",
                          
                          "latest_version": "1.3.25"] as [String : Any]
        
        
        let result = [version1,version2,version3]
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(0, self.model.isFirstNewVersionAtPostion())
    }
    
    func testisbugnilNewVersionAtPostion() {
        
        let result = NSArray()
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 1)
        XCTAssertEqual(0, self.model.isFirstNewVersionAtPostion())
    }
    
    func testisbugnoversionNewVersionAtPostion() {
        
        
        let result = NSArray()
        model.handleVersionArrayToVerionItem(result as NSArray)
        
        XCTAssertEqual(self.model.pageArray.count, 1)
        XCTAssertEqual(0, self.model.isFirstNewVersionAtPostion())
    }
    
}
