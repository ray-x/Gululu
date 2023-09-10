//
//  testCheskupIosVersionIs10.swift
//  Gululu
//
//  Created by Wei on 2016/9/24.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu

class testCheskupIosVersionIs10: XCTestCase {
    var appData: AppData!
    
    override func setUp() {
        super.setUp()
        appData = AppData.share
    }
    
    override func tearDown() {
        super.tearDown()
        appData = nil
    }
    

    
}
