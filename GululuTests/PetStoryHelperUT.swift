//
//  PetStoryHelperUT.swift
//  GululuTests
//
//  Created by baker on 2017/11/28.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu

class PetStoryHelperUT: XCTestCase {
    
    let test_helper = PetStoryHelper.share
    
    override func setUp() {
        super.setUp()
        let media1  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_1",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 2,
                          "media_tag": "1",
                          "media_url": "https://qn.mygululu.com/audio_test.mp3"
            ] as [String : Any]
        
        let media2  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_2",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 2,
                          "media_tag": "2",
                          "media_url": "https://qn.mygululu.com/audio_test.mp3"
            ] as [String : Any]
        
        let media3  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_3",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 2,
                          "media_tag": "3",
                          "media_url": "https://qn.mygululu.com/audio_test.mp3"
            ] as [String : Any]
        
        let media4  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_4",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 2,
                          "media_tag": "4",
                          "media_url": "https://qn.mygululu.com/audio_test.mp3"
            ] as [String : Any]
        
        let media5  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_5",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 0,
                          "media_tag": "5",
                          "media_url": "https://qn.mygululu.com/audio_test.mp3"
            ] as [String : Any]
        
        let media6  = [   "media_name": "ZH-HANS_STORY_WOOD_AUDIO_6",
                          "media_thumbnail_url": "null",
                          "media_avatar": "null",
                          "bionts_status": 0,
                          "media_tag": "6",
                          "media_url": ""
            ] as [String : Any]
        let word1 = [   "world_name":"ocean",
                        "world_lock":1,
                        "world_tag":1,
                        "world_creature" : [media1, media2]
            ] as NSDictionary
        let word2 = [   "world_name":"wood",
                        "world_lock":1,
                        "world_tag":1,
                        "world_creature" : [media3, media4]
            ] as NSDictionary
        
        let word3 = [   "world_name":"desert",
                        "world_lock":0,
                        "world_tag":1,
                        "world_creature" : [media5, media6]
            ] as NSDictionary
        
        let resultPost =  ["status": "OK",
                           "media_info": [word1,word2,word3]
            ]  as NSDictionary
        
        test_helper.handle_pet_story(resultPost)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_handle_pet_story()  {
       
        XCTAssertTrue(test_helper.wood_locked)
        XCTAssertTrue(test_helper.ocean_locked)
        XCTAssertFalse(test_helper.desert_locked)
        
        XCTAssertEqual(test_helper.ocean_array.count, 2)
        XCTAssertEqual(test_helper.wood_array.count, 2)
        XCTAssertEqual(test_helper.desert_array.count, 2)

    }
    
    func test_can_show_pet_story_enter()  {
       XCTAssertNotNil(test_helper.can_show_pet_story_enter(), "error")
    }
    
    func test_get_click_media_info()  {
        let media = test_helper.get_click_media_info(2)
        XCTAssertEqual(media.media_name, "ZH-HANS_STORY_WOOD_AUDIO_2");
        
        let media1 = test_helper.get_click_media_info(3)
        XCTAssertEqual(media1.media_name, "ZH-HANS_STORY_WOOD_AUDIO_3");

        let media2 = test_helper.get_click_media_info(6)
        XCTAssertEqual(media2.media_name, "ZH-HANS_STORY_WOOD_AUDIO_6");
    }
    
    func test_get_all_lock_creature_numbers()  {
        XCTAssertEqual(test_helper.get_all_lock_creature_numbers(), 6);
    }
    
    func test_click_media_info_can_play() {
        XCTAssertFalse(test_helper.click_media_info_can_play(6));
        XCTAssertTrue(test_helper.click_media_info_can_play(5));
    }
    
    func test_creature_is_locked()  {
        XCTAssertFalse(test_helper.creature_is_locked(7));
        XCTAssertFalse(test_helper.creature_is_locked(7));
        XCTAssertTrue(test_helper.creature_is_locked(2));
        XCTAssertTrue(test_helper.creature_is_locked(3));
        XCTAssertFalse(test_helper.creature_is_locked(6));
    }
    
}
