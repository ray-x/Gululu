//
//  TutorialUT.swift
//  Gululu
//
//  Created by Baker on 17/6/29.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class TutorialUT: BaseNewTest {
    
    let model = TutorialHelper.share
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetVedioInfo()  {
        let media1  = [  "media_title": "The story of Gululu Universe",
                         "media_tag": "0",
                         "media_thumbnail_url": "http://gululu.qifei.ren/universe_story_slow_bg.png",
                         "media_url": "http://gululu.qifei.ren/universe_story_slow_en.mp4"
                      ]
        let media2 = [  "media_title": "How to play with Gululu",
                        "media_tag": "1",
                        "media_thumbnail_url": "http://gululu.qifei.ren/how_to_v2_zh_bg.png",
                        "media_url": "http://gululu.qifei.ren/how_to_v2_en.mp4 "
                     ]
        let resultPost =  ["status": "OK", "media_info" : [media1,media2]] as NSDictionary
        
        
        let vedioArray = model.handleResult(resultPost as NSDictionary)
        XCTAssertEqual(vedioArray.count, 2)
        
        let veido = model.readDicFormDefault()
        XCTAssertEqual(veido.count, 2)
        
    }
    
    
    func test_handle_nil_vedio_array() {
        let vedioArray = model.handleVedioArray([NSDictionary]())
        XCTAssertEqual(vedioArray.count, 0)
    }
    
}
