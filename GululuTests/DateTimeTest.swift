//
//  DateTimeTest.swift
//  Gululu
//
//  Created by Baker on 17/9/4.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class DateTimeTest: XCTestCase {
    
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
    
    func test_stringToTimeStamp() {
        let test_str = "2017年08月09日"
        let result = BKDateTime.stringToTimeStamp(test_str)
        XCTAssertEqual(result.count, 10)
    }
    
    func test_timeStampToString() {
        let test_str = "1502208000"
        let result = BKDateTime.timeStampToString(test_str)
        XCTAssertEqual(result, "2017年08月09日")
    }
    
    func test_getAge() {
        let dateFromat = "yyyy-MM-dd"
        
        let lastMouth1 = Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: Date())
        let testStr1 = BKDateTime.getDateStrFormDate(dateFromat, date: lastMouth1!)
        let result_age1 = BKDateTime.getAge(birthdayStr: testStr1)
        XCTAssertEqual(result_age1.1, Localizaed("y.o"))
        XCTAssertEqual(result_age1.0, 1)
        
        let lastMouth2 = Calendar.current.date(byAdding: Calendar.Component.year, value: -2, to: Date())
        let testStr2 = BKDateTime.getDateStrFormDate(dateFromat, date: lastMouth2!)
        let result_age2 = BKDateTime.getAge(birthdayStr: testStr2)
        XCTAssertEqual(result_age2.1, Localizaed("y.o"))
        XCTAssertEqual(result_age2.0, 2)
    }
    
    func testDateFormatePicke() -> Void {
        let nowDate : Date = BKDateTime.getDateFromStr("yyyy/MM/dd", dateStr: "2017/01/05")
        let dateStr1 = BKDateTime.getDateStrFormDate("MMM. dd, yyyy",date: nowDate)
        let dateStr2 = BKDateTime.getDateStrFormDate("yyyy/MM/dd",date: nowDate)
        let dateStr3 = BKDateTime.getDateStrFormDate("yyyy-MM-dd",date:nowDate)
        XCTAssertEqual("2017/01/05", dateStr2)
        XCTAssertEqual("2017-01-05", dateStr3)
        XCTAssertNotNil(dateStr1)
    }
    
    func test_getDateString() {
        let result_str = BKDateTime.getLocalDateString(Date())
        print(result_str)
        XCTAssertEqual(result_str.count, 19)

    }
    
    func test_ageWithDateOfBirth() {
//        let test_date = Date(timeIntervalSinceNow: 100)
    }
    
    func test_getDateArray() {
        let arr = BKDateTime.getDateArray()
        print(arr)
    }

    
}
