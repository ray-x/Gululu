//
//  schoolModelVCTest.swift
//  Gululu
//
//  Created by Baker on 16/9/20.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class schoolModelVCTest: XCTestCase {
    
    let model = GSchoolHepler.share
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testsetKeyTotheDateStrDic() {
        model.setKeyTotheDateStrDic("1", timeValue: "14:00")
        let value1 : String = model.dateStrDic.object(forKey: "1") as! String
        let value2 : String = model.dateStrDic.object(forKey: "2") as! String
        XCTAssertEqual(value2, value1)
        XCTAssertEqual("14:00", value1)
    }
    
}
