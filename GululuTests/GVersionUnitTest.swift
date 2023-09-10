//
//  GVersionUnitTest.swift
//  Gululu
//
//  Created by Baker on 17/2/23.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class GVersionUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testnoNeedUpdateVersion() {
        let iosDic = ["api_required_app_msg" : "0.9 is necessary for gululu cup 2016Q1",
                      "api_required_app_title" : "Update Required",
                      "api_required_app_version" : "0.9",
                      "new_app_msg" : "We've add support for Chinese language in this update!",
                      "new_app_title" : "Update is available",
                      "new_app_version" : "1.0.0"]
        
        GVersion.share.handle_version_info(iosDic)
        
        XCTAssertFalse(GVersion.share.isUpdate)
        XCTAssertFalse(GVersion.share.isForceUpdate)
    }
    
    func testNeedUpdateVersionWhenEqual() {
        let appver = String(format:"%@", GVersion.share.appVer!)
        let iosDic = ["api_required_app_msg" : "0.9 is necessary for gululu cup 2016Q1",
                      "api_required_app_title" : "Update Required",
                      "api_required_app_version" : "1.0.0",
                      "new_app_msg" : "We've add support for Chinese language in this update!",
                      "new_app_title" : "Update is available",
                      "new_app_version" : appver]
        
        GVersion.share.handle_version_info(iosDic)
        
        XCTAssertFalse(GVersion.share.isUpdate)
        XCTAssertFalse(GVersion.share.isForceUpdate)
    }
    
    func testNeedUpdateVersion() {
        let iosDic = ["api_required_app_msg" : "0.9 is necessary for gululu cup 2016Q1",
                      "api_required_app_title" : "Update Required",
                      "api_required_app_version" : "1.0.0",
                      "new_app_msg" : "We've add support for Chinese language in this update!",
                      "new_app_title" : "Update is available",
                      "new_app_version" : "4.15.0"]
        
        GVersion.share.handle_version_info(iosDic)
    
        XCTAssertTrue(GVersion.share.isUpdate)
        XCTAssertFalse(GVersion.share.isForceUpdate)
    }
    
    func testNeedFroceUpdateVersion() {
        let iosDic = ["api_required_app_msg" : "0.9 is necessary for gululu cup 2016Q1",
                      "api_required_app_title" : "Update Required",
                      "api_required_app_version" : "4.5.3",
                      "new_app_msg" : "We've add support for Chinese language in this update!",
                      "new_app_title" : "Update is available",
                      "new_app_version" : "1.5.3"]
        
        GVersion.share.handle_version_info(iosDic)
        
        XCTAssertFalse(GVersion.share.isUpdate)
        XCTAssertTrue(GVersion.share.isForceUpdate)
    }
    
    func testCompareVersion() {
        XCTAssertEqual(0, GVersion.share.compareVersion("1.1.0", version2: "1.1.0"))
        XCTAssertEqual(-1, GVersion.share.compareVersion("1.1.0", version2: "1.1.1"))
        XCTAssertEqual(1, GVersion.share.compareVersion("1.1.0", version2: "1.0.9"))
        XCTAssertEqual(0, GVersion.share.compareVersion("", version2: ""))
        XCTAssertEqual(-1, GVersion.share.compareVersion("", version2: "1.1.0"))
        XCTAssertEqual(1, GVersion.share.compareVersion("1.1.0", version2: ""))
        XCTAssertEqual(-1, GVersion.share.compareVersion("1.8.0", version2: "1.10.0"))
    }
    
    
}
