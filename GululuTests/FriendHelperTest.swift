//
//  FriendHelperTest.swift
//  GululuTests
//
//  Created by Baker on 2017/10/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class FriendHelperTest: XCTestCase {
    
    let test_helper = FriendHelper.share
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_handle_child_list_to_model(){
        let pet1 = ["pet_current_depth" : 1240,
                    "pet_current_level" : 1,
                    "pet_model" : "NINJI2",
                    "update_time" : "2017-10-19 03:39:17",
                    "x_pet_sn" : "8W4IT0HPOXFY"
            ] as [String : Any]
        let habit1 = [ "score" : 60,
                      "update_time" : "2017-10-27 07:01:13"
            ] as [String : Any]
        let files1 = ["filename" : "9350IGECS2XH.640.jpg",
                      "size" : 640,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.640.jpg"
            ] as [String : Any]
        let files2 = ["filename" : "9350IGECS2XH.320.jpg",
                      "size" : 320,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.320.jpg"
            ] as [String : Any]
        let files3 = ["filename" : "9350IGECS2XH.160.jpg",
                      "size" : 160,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.160.jpg"
            ] as [String : Any]
        let files = [files1, files2, files3]
        let child1 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit1,
                      "nickname" : "baker",
                      "pet" : pet1,
                      "profile" : ["files" : files, "updated_time":"2016-12-26 08:08:10"],
                      "x_child_sn" : "9350IGECS2XH"
            ] as [String : Any]
        let pet2 = [:] as [String : Any]
        let habit2 = [:] as [String : Any]

        let child2 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit2,
                      "nickname" : "baker",
                      "pet" : pet2,
                      "profile" : [:],
                      "x_child_sn" : "9350IGECS2Xd"
            ] as [String : Any]
        let result = [
            "status": "OK",
            "child_list" : [child1,child2]
            ] as [String : Any]
        let friend_array = test_helper.handle_child_list_to_model(result as NSDictionary)
        XCTAssertEqual(friend_array.count, 2)
        
    }
    
    func test_handle_query_pending_friend() {
        let pet1 = ["pet_current_depth" : 1240,
                    "pet_current_level" : 1,
                    "pet_model" : "NINJI2",
                    "update_time" : "2017-10-19 03:39:17",
                    "x_pet_sn" : "8W4IT0HPOXFY"
            ] as [String : Any]
        let habit1 = [ "score" : 60,
                       "update_time" : "2017-10-27 07:01:13"
            ] as [String : Any]
        let files1 = ["filename" : "9350IGECS2XH.640.jpg",
                      "size" : 640,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.640.jpg"
            ] as [String : Any]
        let files2 = ["filename" : "9350IGECS2XH.320.jpg",
                      "size" : 320,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.320.jpg"
            ] as [String : Any]
        let files3 = ["filename" : "9350IGECS2XH.160.jpg",
                      "size" : 160,
                      "url" : "http://dev.cn.mygululu.com:8080/resource/profile/935/9350IGECS2XH.160.jpg"
            ] as [String : Any]
        let files = [files1, files2, files3]
        let child1 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit1,
                      "nickname" : "baker",
                      "pet" : pet1,
                      "profile" : ["files" : files, "updated_time":"2016-12-26 08:08:10"],
                      "x_child_sn" : "9350IGECS2XH"
            ] as [String : Any]
        let pet2 = [:] as [String : Any]
        let habit2 = [:] as [String : Any]
        
        let child2 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit2,
                      "nickname" : "baker",
                      "pet" : pet2,
                      "profile" : [:],
                      "x_child_sn" : "9350IGECS2Xd"
            ] as [String : Any]
        
        let child3 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit1,
                      "nickname" : "baker",
                      "pet" : pet1,
                      "profile" : ["files" : files, "updated_time":"2016-12-26 08:08:10"],
                      "x_child_sn" : "9350IGECS2XH"
            ] as [String : Any]
        
        let child4 = ["birthday" : "2009-03-26 00:00:00",
                      "child_enabled" : 1,
                      "habit" : habit2,
                      "nickname" : "baker",
                      "pet" : pet2,
                      "profile" : [:],
                      "x_child_sn" : "9350IGECS2Xd"
            ] as [String : Any]
        let result = [
            "status": "OK",
            "reject_pending_friends" : [child1,child2],
            "adding_pending_friends" : [child3, child4]
            ] as [String : Any]
        test_helper.handle_query_pending_friend(result as NSDictionary)
        XCTAssertEqual(test_helper.reject_pending_friends.count, 2)
        XCTAssertEqual(test_helper.adding_pending_friends.count, 2)

    }
    
    func test_save_child_friends_data() {
        let friend1 = Friend()
        friend1.nickname = "ddd"
        friend1.habitScore = "60"
        
        let friend2 = Friend()
        friend2.nickname = "3333"
        friend2.habitScore = "100"
        test_helper.friendList.append(friend1)
        test_helper.friendList.append(friend2)
        
//        test_helper.save_child_friends_data()
    }
    
    func test_read_child_friends_data() {
        let friend1 = Friend()
        friend1.nickname = "ddd"
        friend1.habitScore = "60"
        
        let friend2 = Friend()
        friend2.nickname = "3333"
        friend2.habitScore = "100"
        test_helper.friendList.append(friend1)
        test_helper.friendList.append(friend2)
        
//        test_helper.save_child_friends_data()
        
        test_helper.friendList.removeAll()
        test_helper.read_child_friends_data()
        XCTAssertEqual(test_helper.friendList.count , 0)
    }
    
    func test_checkout_friend() {
        XCTAssertFalse(test_helper.checkout_friend("test"))

        let friend1 = Friend()
        friend1.nickname = "ddd"
        friend1.habitScore = "60"
        friend1.x_child_sn = "test"
        
        let friend2 = Friend()
        friend2.nickname = "3333"
        friend2.habitScore = "100"
        test_helper.friendList.append(friend1)
        test_helper.friendList.append(friend2)
        
        XCTAssertTrue(test_helper.checkout_friend("test"))
        XCTAssertFalse(test_helper.checkout_friend("test111"))
    }
    
    func test_check_show_message_view() {
        XCTAssertFalse(test_helper.check_show_message_view())
        let friend1 = Friend()
        friend1.nickname = "ddd"
        friend1.habitScore = "60"
        friend1.x_child_sn = "test"
        test_helper.adding_pending_friends.append(friend1)
        XCTAssertTrue(test_helper.check_show_message_view())
        test_helper.reject_pending_friends.append(friend1)
        XCTAssertTrue(test_helper.check_show_message_view())
        test_helper.adding_pending_friends.removeAll()
        test_helper.reject_pending_friends.removeAll()
        XCTAssertFalse(test_helper.check_show_message_view())
    }
    
    
}
