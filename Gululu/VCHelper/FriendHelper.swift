//
//  FriendHelper.swift
//  Gululu
//
//  Created by Baker on 2017/10/23.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class FriendHelper: NSObject {

    static let share = FriendHelper()
    var adding_pending_friends = [Friend]()
    var reject_pending_friends = [Friend]()
    var friendList = [Friend]()
    var search_friends = [Friend]()
    
    var friend_list_show_message_falg: Bool = false
    var friend_list_show_height: CGFloat = 84
    let agree = "agree"
    let finish = "finish"
    let reject = "reject"
    var search_account: String = ""
    var friend_red_sing: Bool = false
    
    func get_child_friends( cloudCallback:@escaping (Bool)->Void)  {
        
        friendList.removeAll()
        let requset = GUHttpRequest()
        requset.setRequestConfig(.get, url: get_child_friend)
        requset.header["x_child_sn"] = activeChildID
        requset.handleRequset(callback: { result in
            if result.boolValue{
                self.handle_child_friends(result.value!)
                cloudCallback(true)
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func save_child_friends_data()  {
        let key = activeChildID + main_child_friends_key
        let friends_data = NSKeyedArchiver.archivedData(withRootObject: friendList)
        UserDefaults.standard.set(friends_data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func read_child_friends_data(){
        if friendList.count != 0{
            return
        }
        let key = activeChildID + main_child_friends_key
        let friends_data: Data? = UserDefaults.standard.object(forKey: key) as? Data
        if friends_data == nil{
            return
        }
        self.friendList.removeAll()
        self.friendList = NSKeyedUnarchiver.unarchiveObject(with: friends_data!) as! [Friend]
    }
    
    func create_myself_friend() -> Friend {
        let mySelf = Friend()
        mySelf.x_child_sn = activeChildID
        if isValidString(activeChildID){
            let petList:[Pets]? = createObjects(Pets.self,id:activeChildID) as? [Pets]
            if petList?.count == 0 || petList == nil{
                return Friend()
            }else{
                let active_pet_pet_model = GPet.share.getActivePetName()
                mySelf.pet_model = active_pet_pet_model
            }
        }else{
            mySelf.pet_model = "Ninji"
        }
        
        let myHabitx = GChild.share.readHabitIndex()
        mySelf.habitScore = String(myHabitx)
        
        if GChild.share.getActiveChildName() == ""{
            mySelf.nickname = Localizaed("Me")
        }else{
            mySelf.nickname = GChild.share.getActiveChildName()
        }
        return mySelf
    }
    
    func handle_child_friends(_ dic: NSDictionary){
        let child_list: [NSDictionary] = dic.object(forKey: "friends") as! [NSDictionary]
        for child : NSDictionary in child_list{
            friendList.append(data_to_friend_model(child))
        }
        if friendList.count == 0{
            return
        }else{
            friendList.append(create_myself_friend())
            friendList.sort(by: {Int($0.habitScore!) > Int($1.habitScore!)})
        }
    }
    
    func serach_friend_by_user_account(_ userAccount: String, _ cloudCallback:@escaping (Int)->Void) {
        if !GUserConfigUtil.share.checkout_add_frined(){
            cloudCallback(0)
        }
        let requset = GUHttpRequest()
        requset.setRequestConfig(.get, url: get_search_friend_url(userAccount))
        requset.handleRequset(callback: { result in
            self.search_friends.removeAll()
            if result.boolValue{
                self.search_friends = self.handle_child_list_to_model(result.value!)
                cloudCallback(1)
            }else{
                let err = result.error! as NSError
                let dic_err = err.userInfo as NSDictionary
                let extra_info: String? = dic_err.object(forKey: "extra_info") as? String
                if extra_info == "db no this account"{
                    cloudCallback(2)
                }else{
                    cloudCallback(0)
                }
            }
        })
    }
    
    func handle_child_list_to_model(_ dic: NSDictionary) -> [Friend] {
        let child_list: [NSDictionary] = dic.object(forKey: "child_list") as! [NSDictionary]
        var friend_array = [Friend]()
        for child : NSDictionary in child_list{
            friend_array.append(data_to_friend_model(child))
        }
        return friend_array
    }
    
    func data_to_friend_model(_ child: NSDictionary) -> Friend {
        let friend = Friend()
        friend.nickname = child.object(forKey:"nickname") as? String
        friend.x_child_sn = child.object(forKey: "x_child_sn") as? String
        friend.birthday = child.object(forKey: "birthday") as? String
        friend.avatar_url = get_file_640_url(child.object(forKey:"profile") as? NSDictionary)
        if isValidString(friend.avatar_url){
            if(!GUser.share.isExistFriendInChildList(friend.x_child_sn!))
            {
                AvatorHelper.share.removeChildAvator(friend.x_child_sn!)
            }
            AvatorHelper.share.getPhotoWithURL((friend.x_child_sn, friend.avatar_url))
        }
        friend.habitScore = get_habit_score(child.object(forKey: "habit") as? NSDictionary)
        friend.pet_model = get_pet_model(child.object(forKey: "pet") as? NSDictionary)
        friend.x_pet_sn = get_x_pet_sn(child.object(forKey: "pet") as? NSDictionary)
        friend.pet_current_depth = get_pet_current_depth(child.object(forKey: "pet") as? NSDictionary)
        friend.pet_current_level = get_pet_current_level(child.object(forKey: "pet") as? NSDictionary)
        if (child.object(forKey: "add_friend_status") != nil){
            friend.add_friend_status = set_add_friend_status((child.object(forKey: "add_friend_status") as? String)!)
        }
        return friend
    }
    
    func set_add_friend_status(_ status: String) -> AddFriendStatus{
        if status == "ok"{
            return .ok
        }else if status == "add"{
            return .add
        }else if status == "adding"{
            return .adding
        }else{
            return .add
        }
    }
    
    func get_file_640_url(_ dic: NSDictionary?)  -> String{
        if dic == nil || dic?.count == 0{
            return ""
        }
        let files_array: [NSDictionary]? = dic?.object(forKey: "files") as? [NSDictionary]
        if files_array == nil{
            return ""
        }
        for file:NSDictionary in files_array!{
            let size: Int = file.object(forKey: "size") as! Int
            if size == 640{
                return file.object(forKey: "url") as! String
            }
        }
        return ""
    }
    
    func get_habit_score(_ dic: NSDictionary?) -> String {
        if dic == nil || dic?.count == 0{
            return "60"
        }
        let score = dic?.object(forKey: "score") as? NSNumber
        return score!.stringValue
    }
    
    func get_pet_model(_ dic: NSDictionary?) -> String {
        if dic == nil || dic?.count == 0{
            return ""
        }
        return dic?.object(forKey: "pet_model") as! String
    }
    
    func get_x_pet_sn(_ dic: NSDictionary?) -> String {
        if dic == nil || dic?.count == 0{
            return ""
        }
        return dic?.object(forKey: "x_pet_sn") as! String
    }
    
    func get_pet_current_level(_ dic: NSDictionary?) -> String {
        if dic == nil || dic?.count == 0{
            return ""
        }
        let pet_current_level = dic?.object(forKey: "pet_current_level") as? NSNumber
        return pet_current_level!.stringValue
    }
    
    func get_pet_current_depth(_ dic: NSDictionary?) -> String {
        if dic == nil || dic?.count == 0{
            return ""
        }
        let pet_current_depth = dic?.object(forKey: "pet_current_depth") as? NSNumber
        return pet_current_depth!.stringValue
    }
    
    func post_pending_friend(_ x_child_sn: String, _ cloudCallback:@escaping (Int)->Void) {
        if !GUserConfigUtil.share.checkout_add_frined(){
            cloudCallback(2)
        }
        let requset = GUHttpRequest()
        requset.setRequestConfig(.post, url: get_post_a_pending_friend_url())
        requset.body["target_x_child_sn"] = x_child_sn
        requset.handleRequset(callback: { result in
            if result.boolValue{
                cloudCallback(0)
            }else{
                let err = result.error! as NSError
                let dic_err = err.userInfo as NSDictionary
                let extra_info: String? = dic_err.object(forKey: "extra_info") as? String
                if extra_info == "cannot add yourself"{
                    cloudCallback(1)
                }else{
                    cloudCallback(2)
                }
            }
        })
    }
    
    func handle_post_add_friend_error_msg()  {
        
    }
    
    func query_pending_fiends(_ cloudCallback:@escaping (Bool)->Void ){
        adding_pending_friends.removeAll()
        reject_pending_friends.removeAll()

        if !GUserConfigUtil.share.checkout_add_frined(){
            cloudCallback(false)
        }
        let requset = GUHttpRequest()
        requset.setRequestConfig(.get, url: get_query_pending_friends_url())
        requset.handleRequset(callback: { result in
            if result.boolValue{
                self.handle_query_pending_friend(result.value!)
                 cloudCallback(true)
            }else{
                self.friend_red_sing = false
                cloudCallback(false)
            }
        })
    }
    
    func handle_query_pending_friend(_ dic: NSDictionary) {
        let adding_pending_friends_dic:[NSDictionary] = dic.object(forKey: "adding_pending_friends") as! [NSDictionary]
        for child : NSDictionary in adding_pending_friends_dic{
            adding_pending_friends.append(data_to_friend_model(child))
        }
        
        let reject_pending_friends_dic:[NSDictionary] = dic.object(forKey: "reject_pending_friends") as! [NSDictionary]
        for child : NSDictionary in reject_pending_friends_dic{
            reject_pending_friends.append(data_to_friend_model(child))
        }

        handle_friend_count()
        save_unread_add_friend_message_count()
    }
    
    func handle_friend_count() {
        let new_count = adding_pending_friends.count + reject_pending_friends.count
        let last_save_count = read_unread_add_friend_message_count()
        if new_count == 0{
            friend_red_sing = false
            return
        }
        if last_save_count < new_count{
            friend_red_sing = true
        }else if last_save_count == new_count{
            handle_read_click_friend_button()
        }else{
            friend_red_sing = false
        }
    }
    
    func handle_read_click_friend_button()  {
        if read_click_friend_button_para(){
            friend_red_sing = false
        }else{
            friend_red_sing = true
        }
    }
    
    func read_click_friend_button_para() -> Bool {
        let key = activeChildID + click_main_friend_button_key
        let click : Bool? = UserDefaults.standard.object(forKey: key) as? Bool
        if click == nil{
            return false
        }else{
            return click!
        }
    }
    
    func save_click_friend_button_para(_ click: Bool)  {
        let key = activeChildID + click_main_friend_button_key
        UserDefaults.standard.set(click, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func save_unread_add_friend_message_count() {
        let count = adding_pending_friends.count + reject_pending_friends.count
        let key = activeChildID + add_friend_message_count_key
        UserDefaults.standard.set(count, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func read_unread_add_friend_message_count()  -> Int{
        let key = activeChildID + add_friend_message_count_key
        let count : Int? = UserDefaults.standard.object(forKey: key) as? Int
        if count == nil{
            return 0
        }
        return count!
    }
    
    func check_show_friend_red_sing() -> Bool {
        return friend_red_sing
    }
    
    func check_show_message_view() -> Bool {
        if adding_pending_friends.count != 0 || reject_pending_friends.count != 0{
            return true
        }else{
            return false
        }
    }
    
    func handle_pending_friend_by_target(_ permit:String, request_child_sn:String, _ cloudCallback:@escaping (Bool)->Void) {
        if !GUserConfigUtil.share.checkout_add_frined(){
            cloudCallback(false)
        }
        let requset = GUHttpRequest()
        requset.setRequestConfig(.put, url: get_handle_pending_friend_url())
        requset.body["request_x_child_sn"] = request_child_sn
        requset.body["permit"] = permit
        requset.handleRequset(callback: { result in
            if result.boolValue{
                self.handle_target_pending_friend_result(permit)
                cloudCallback(true)
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func handle_target_pending_friend_result(_ permit: String) {
        let friend = self.adding_pending_friends.first
        self.adding_pending_friends.removeFirst()
        if permit == self.agree{
            self.friendList.append(friend!)
            if self.friendList.count == 1{
                self.friendList.append(self.create_myself_friend())
            }
            self.friendList.sort(by: {$0.habitScore > $1.habitScore})
        }
        save_unread_add_friend_message_count()
    }
    
    func handle_pending_friend_by_request(_ permit:String, request_child_sn:String, _ cloudCallback:@escaping (Bool)->Void) {
        if !GUserConfigUtil.share.checkout_add_frined(){
            cloudCallback(false)
        }
        let requset = GUHttpRequest()
        requset.setRequestConfig(.put, url: get_post_a_pending_friend_url())
        requset.body["target_x_child_sn"] = request_child_sn
        requset.body["permit"] = permit
        requset.handleRequset(callback: { result in
            self.handle_request_pending_friend_result()
            if result.boolValue{
                cloudCallback(true)
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func handle_request_pending_friend_result()  {
        reject_pending_friends.removeFirst()
        save_unread_add_friend_message_count()
    }
    
    func checkout_friend(_ x_child_sn: String) -> Bool {
        if friendList.count == 0{
            return false
        }
        for friend in friendList{
            if friend.x_child_sn == x_child_sn{
                return true
            }
        }
        return false
    }
    
}
