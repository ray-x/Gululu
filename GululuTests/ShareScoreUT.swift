//
//  ShareScoreUT.swift
//  GululuTests
//
//  Created by Gululu on 2017/11/15.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class ShareScoreUT: XCTestCase {
    
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
    
    func test_get_share_title_img_and_info_1()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(0)
        XCTAssertEqual(image_name, "main_share_oops")
        XCTAssertEqual(info, Localizaed("We miss you badly, come back and drink."))
        
    }
    
    func test_get_share_title_img_and_info_2()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(67)
        XCTAssertEqual(image_name, "main_share_oops")
        XCTAssertEqual(info, String(format: Localizaed("You beat %d %% of the other Gululu users! Every single sip matters for the Gululu uninverse."),17))
        
    }
    
    func test_get_share_title_img_and_info_3()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(77)
        XCTAssertEqual(image_name, "main_share_goodjob")
        XCTAssertEqual(info, String(format:Localizaed("Well done! You beat %d %% of the other Gululu users from all over the world! Keep drinking and keep healthy!"),42))
        
    }
    
    func test_get_share_title_img_and_info_4()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(86)
        XCTAssertEqual(image_name, "main_share_rock")
        XCTAssertEqual(info, String(format:Localizaed("Super fan of Gululu? Ah-ha, You beat %d %% of the other Gululu users, are you ready for new challenges?"),65))
        
    }
    
    func test_get_share_title_img_and_info_5()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(97)
        XCTAssertEqual(image_name, "main_share_superstar")
        XCTAssertEqual(info, String(format:Localizaed("You beat %d %% of the other Gululu users! Mommy will never be worried about your water drinking!"),92))
        
    }
    
    func test_get_share_title_img_and_info_6()  {
        let (image_name, info) = ShareScoreHelper.share.get_share_title_img_and_info(100)
        XCTAssertEqual(image_name, "main_share_legend")
        XCTAssertEqual(info, Localizaed("Wow amazing job drinking water and using Gululu! Drinking water is something fabulous in your life!!"))
        
    }
    
    func test_get_share_day_all_image()  {
//        MagicMock("fun_name").return_value = ""
    }
    
}
