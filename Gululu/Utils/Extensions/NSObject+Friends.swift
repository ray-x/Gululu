//
//  NSObject+Friends.swift
//  Gululu
//
//  Created by Ray Xu on 31/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import Foundation
import CoreData

extension NSObject {
    func convert2Friends(_ dict:NSDictionary) {

        var id = dict["x_child_sn"] as? String
        if id == nil
        {
            id = activeChildID
            print("school time error")
            return
        }
        else
        {
            (self as! Friends).childID = id
        }

        let friends = dict["friends"] as? Array<NSDictionary>
        if friends != nil {
            friends?.forEach({ (friend) in
                if friend["x_child_sn"] as? String == nil {
                    print("child SN not valid")
                    // not a valid request
                    return
                }
                var friendMOF:Friends?=createObject(Friends.self, objectID:friend["x_child_sn"] as? String )
                if friendMOF == nil {
                    friendMOF=createObject(Friends.self)
                }
                if  friendMOF!.friendID  != (friend["x_child_sn"] as! String) {
                    friendMOF!.friendID   =  friend["x_child_sn"] as? String
                }
                if  friendMOF!.friendBirthday != friend["birthday"]as? String {
                    friendMOF!.friendBirthday  = friend["birthday"]as? String
                }
                if  friendMOF!.childID != id { friendMOF!.childID=id }
                if  friendMOF!.friendName != friend["nickname"] as? String {
                    friendMOF!.friendName  = friend["nickname"] as? String
                }
                if  friendMOF!.friendPetLevel != ((friend["pet"] as! NSDictionary)["pet_current_level"] as! NSNumber) {
                    friendMOF!.friendPetLevel  = ((friend["pet"] as! NSDictionary)["pet_current_level"] as! NSNumber)
                }
                if  friendMOF!.friendPet != (friend["pet"]as! NSDictionary)["pet_model"] as? String {
                    friendMOF!.friendPet = (friend["pet"]as! NSDictionary)["pet_model"] as? String
                }

                if friendMOF!.friendhabitIdx != (friend["habit"]as! NSDictionary)["score"] as? NSNumber {
                    friendMOF!.friendhabitIdx = (friend["habit"]as! NSDictionary)["score"] as? NSNumber
                }
                if let profile = friend["profile"] as?  NSDictionary {
                    if let files = profile["files"] as? NSArray {
                        if files.count>0 {
                            if friendMOF!.friendPhotoURL != (files[1] as! NSDictionary)["url"] as? String {
                                friendMOF!.friendPhotoURL = (files[1] as! NSDictionary)["url"] as? String
                            }
                        }
                    }
                }
                if (friendMOF!.friendPhotoURL != nil) {
                    AvatorHelper.share.getPhotoWithURL((friendMOF!.friendID, friendMOF!.friendPhotoURL))
                }
                if (friendMOF! as NSManagedObject).managedObjectContext == nil {
                    backgroundMoc!.insert(friendMOF! as NSManagedObject)
                }
                saveContext()
            })
        }
    }
}
