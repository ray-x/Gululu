//
//  Friend.swift
//  Gululu
//
//  Created by Baker on 2017/10/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

enum AddFriendStatus {
    case add, adding, ok
}

class Friend: NSObject {
    var x_child_sn: String?
    var nickname: String?
    var avatar_url: String?
    var birthday: String?
    var habitScore: String?
    var pet_model: String?
    var pet_current_depth: String?
    var pet_current_level: String?
    var x_pet_sn:String?
    var add_friend_status: AddFriendStatus = .add
    
    func model_to_db()  {
        let friend_db : Friends  = createObject(Friends.self)!
        friend_db.friendID = self.x_child_sn
        friend_db.friendName = self.nickname
        friend_db.friendPet = self.pet_model
        friend_db.childID = activeChildID
        friend_db.friendPhotoURL = self.avatar_url
        friend_db.friendBirthday = self.birthday
        friend_db.friendPetDepth = NSNumber(value: Int(self.pet_current_depth!)!)
        friend_db.friendPetLevel = NSNumber(value: Int(self.pet_current_level!)!)
        friend_db.friendPet = self.x_pet_sn
        backgroundMoc?.insert(friend_db)
        saveContext()
    }
    
    func db_to_model(_ friend_db: Friends) -> Friend{
        let friend_model = Friend()
        friend_model.x_child_sn = friend_db.friendID
        friend_model.nickname = friend_db.friendName
        friend_model.pet_model = friend_db.friendPet
        friend_model.avatar_url = friend_db.friendPhotoURL
        friend_model.birthday = friend_db.friendBirthday
        friend_model.pet_current_depth = friend_db.friendPetDepth?.stringValue
        friend_model.pet_current_level = friend_db.friendPetLevel?.stringValue
        friend_model.x_pet_sn = friend_db.friendPet
        return friend_model
    }
    
    func fetch_all_friend_by_childid() -> [Friend] {
        let db_friend_array:[Friends]? = createObjects(Friends.self,id:activeChildID) as? [Friends]
        var friend_model_array = [Friend]()
        for friends_db in db_friend_array! {
            let friend_model = self.db_to_model(friends_db)
            friend_model_array.append(friend_model)
        }
        return friend_model_array
    }
    
    func delete_all_friend_by_childid() {
        let db_friend_array:[Friends]? = createObjects(Friends.self,id:activeChildID) as? [Friends]
        for friends_db in db_friend_array! {
            backgroundMoc?.delete(friends_db)
        }
        saveContext()
    }
    
}
