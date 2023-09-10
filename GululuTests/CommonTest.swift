//
//  CommonTest.swift
//  Gululu
//
//  Created by Baker on 16/7/15.
//  Copyright © 2016年 w19787. All rights reserved.
//

import XCTest
@testable import Gululu
class CommonTest: XCTestCase {
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
    
    func testNetWorkIsConnect() -> Void {
        let isConnecting : Bool = BaseViewController().checkInternetConnection()
        XCTAssertTrue(isConnecting, "connect fail,please check the neck work")
    }
    
    func testIsaVailedEmail() -> Void {
        var email : String = "baker.cheng@qq.com"
        XCTAssertTrue(Common.isValidEmail(email))
        
        email = "baker.cheng@qq.com.cn"
        XCTAssertTrue(Common.isValidEmail(email))
        
        email = "baker.cheng@qq.com.cn.cd"
        XCTAssertTrue(Common.isValidEmail(email))
        
        email = "baker...cheng@qq.com.cn"
        XCTAssertTrue(Common.isValidEmail(email))
        
    }
    
    func testIsaVailedMobile_1() -> Void {
        let mobile : String = "17721149222"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertTrue(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_2() -> Void {
        let mobile : String = "23234"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertFalse(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_3() -> Void {
        let mobile : String = "23498472944"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertFalse(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_4() -> Void {
        let mobile : String = "19939203920"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertTrue(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_5() -> Void {
        let mobile : String = "99999999999"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertFalse(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_6() -> Void {
        let mobile : String = "1222222"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertFalse(isaVailedmobilel)
    }
    
    func testIsaVailedMobile_7() -> Void {
        let mobile : String = "122222244445555"
        let isaVailedmobilel : Bool  =  Common.isValidMobile(mobile)
        XCTAssertFalse(isaVailedmobilel)
    }

    func textCheckTextUniqueCharacter() -> Void {
        let testStr : String = "djfa123*&&%$"
        let isvailedStr : Bool = Common.checkTextUniqueCharacter(testStr)
        XCTAssertTrue(isvailedStr)

    }
    
    func testAStrLengthSix() -> Void {
        let testStr : String = "123456"
        let isSixString : Bool = Common.checkStringLengthBigThanSix(testStr,strLength:6)
        XCTAssert(isSixString, "str must be than six length")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testBirthdayFormatEngBigWord()-> Void {
        let bir = "2016-09-08 12:12:12"
        let engBir = Common.birthdayFormatEngBigWord(bir)
        if Common.checkPreferredLanguages() == 0{
            XCTAssertEqual("Sep, 2016", engBir)
        }else{
            XCTAssertEqual("2016年9月", engBir)
        }
    }
    
    func testCheckStringIsCnOrEn() {
        XCTAssertEqual(1, Common.checkStringIsCnOrEn(string: "在"))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: "1"))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: ""))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: " "))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: nil))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: "a"))
        XCTAssertEqual(0, Common.checkStringIsCnOrEn(string: "😊"))
        XCTAssertEqual(1, Common.checkStringIsCnOrEn(string: "好"))
        XCTAssertEqual(1, Common.checkStringIsCnOrEn(string: "呀"))
        XCTAssertEqual(1, Common.checkStringIsCnOrEn(string: "嗯"))
    }
    
    func testCount() {
        XCTAssertEqual(5, Common.countStingCnAndEnCount(string: "qwefv"))
        XCTAssertEqual(6, Common.countStingCnAndEnCount(string: "嗯嗯嗯"))
        XCTAssertEqual(11, Common.countStingCnAndEnCount(string: "阿斯顿发efv"))
    }
    
    func testcheckStrHaveEmoji() {
        var  string = "sdfavas!@#$%^&*()_+=-][[]"
        XCTAssertFalse(Common.checkStrHaveEmoji(string))

        string = "🐶🐱😄🐶😄😂☠️"
        XCTAssertTrue(Common.checkStrHaveEmoji(string))
    }
    
    func test_checkPreferredLanguagesIsOnlyZh() {
        _ = Common.checkPreferredLanguagesIsOnlyZh()
    }
    

    
    
}
