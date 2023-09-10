//
//  AvatorTest.swift
//  Gululu
//
//  Created by Baker on 17/8/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class AvatorTest: XCTestCase {
    
    let model = AvatorHelper.share

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWriteImageInDocument() -> Void {
        let Image : UIImage = UIImage(named: "boyAvatar")!
        
        let Url : URL =  model.getImageFromDocumentPathURLWithID("test")
        
        model.writeDocumetFormPath(Url.path, andImage: Image)
        
        let isexist : Bool = model.isAvatorFileExist(Url)
        
        XCTAssertTrue(isexist, "the file have not in document")
        
        let backUrl : URL =  model.getBackImageInDocumentPathURLWithID("test")
        model.writeDocumetFormPath(backUrl.path, andImage: Image)
        
        let isbackExist : Bool = model.isAvatorFileExist(backUrl)
        
        XCTAssertTrue(isbackExist, "the back file have not in document")
        
    }
    
    func testCloudimage() {
        let image =  model.dataimage(nil)
        XCTAssertNotNil(image)
    }
    
}
