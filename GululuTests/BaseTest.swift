//
//  MockObject.swift
//  Gululu
//
//  Created by Baker on 17/2/10.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class BaseTest: XCTestCase {
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    /**
      berfore you test .please logout you app.
     **/
    override func setUp() {
        super.setUp()
        BaseObject.share.cloudObject = MockCloudCommon.mockShareObject
        appdelegate.managedObjectContext = MockCoreData.mockShareObject.setUpInMemoryManagedObjectContext()
        backgroundMoc = appdelegate.managedObjectContext
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
