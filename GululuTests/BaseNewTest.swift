//
//  BaseNewTest.swift
//  Gululu
//
//  Created by Baker on 17/4/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class BaseNewTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
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
