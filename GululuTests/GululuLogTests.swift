//
//  GululuLogTests.swift
//  Gululu
//
//  Created by Wei on 6/21/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class GululuLogTests: BaseTest {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetLevelDescription()
    {
        let pairInfo = getLogInfo(.pair)
        XCTAssertEqual(pairInfo.mode, "Pair")
        XCTAssertEqual(pairInfo.fileName, "gululu.log")
        
        let testInfo = getLogInfo(.info)
        XCTAssertEqual(testInfo.mode, "Info")
        XCTAssertEqual(testInfo.fileName, "gululu.log")
    }
    
    func testgetLocalDateString()
    {
        let dateStr = BKDateTime.getLocalDateString(Date())
        XCTAssertNotNil(dateStr)
        XCTAssertEqual(dateStr.count, "yyyy-MM-dd HH:mm:ss".count)
    }
    
    func testGetLogFilePathURL()
    {
        let fileURL = BHGululuLog().getLogFilePathURLWithFileName("test.log")
        XCTAssertNotNil(fileURL)
        XCTAssertNotNil(fileURL.path)
        XCTAssertTrue(fileURL.path.range(of: "test.log") != nil)
    }
    
    func testWriteGululuLog()
    {
        let fileURL = BHGululuLog().getLogFilePathURLWithFileName("gululu.log")
        try! FileManager.default.removeItem(at: fileURL)
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
        
        BH_Log("GululuLog: Line 1", logLevel: .info)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        
        let readInfo1 = BHGululuLog().readFromLogFile("gululu.log")
        XCTAssertTrue(readInfo1.success)
        XCTAssertEqual(readInfo1.error, "")
        XCTAssertTrue((readInfo1.content.range(of:"GululuLog: Line 1")) != nil)
        
        let fileSize1 = BHGululuLog().logFileSize("gululu.log")
        XCTAssertTrue(fileSize1 > 0)
        
        BH_Log("GululuLog: Line 2", logLevel: .info)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        
        let fileSize2 = BHGululuLog().logFileSize("gululu.log")
        XCTAssertTrue(fileSize2 > fileSize1)
        
        let readInfo2 = BHGululuLog().readFromLogFile("gululu.log")
        XCTAssertTrue(readInfo2.success)
        XCTAssertEqual(readInfo2.error, "")
        XCTAssertTrue((readInfo2.content.range(of:"GululuLog: Line 2")) != nil)
    }
    
    func testRemoveLogFile()
    {
        let fileURL = BHGululuLog().getLogFilePathURLWithFileName("test.log")
        BH_Log("GululuLog: Line 1", logLevel: .info)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        
        BHGululuLog().removeLogFile("test.log")
        XCTAssertFalse(FileManager.default.fileExists(atPath: fileURL.path))
    }
    
    func testPosxtPairLogFile() {

        let varstr = "2016-12-23 11:46:48.856 [Pair]: type: update\n2016-12-23 11:46:48.858 [Pair]: gululu ap: + UF2CE\n2016-12-23 11:46:50.868 [Pair]: ssid:gululu\n2016-12-23 11:46:50.903 [Pair]: ssid: ok\n2016-12-23 11:46:50.904 [Pair]: pwd: Length = 12\n2016-12-23 11:46:50.928 [Pair]: pwd: ok\n2016-12-23 11:46:50.930 [Pair]: tosta\n2016-12-23 11:46:50.959 [Pair]: tosta ok\n"
        MockCloudCommon.mockShareObject.resultPost = ["status" : 1,"x_child_sn" : "6GYAQVN712ZP"]

        cloudObj().uploadDiagnostic(varstr, cloudCallback: { r in
            if case .Success = r {
                print("upload log successed")
            }else{
                XCTAssert(true , "reset failed")
            }
        })
    }
    
    func test_log() {
        BH_Log_New(.info, "just ddd curpe dajdf")
    }
    
    
}
