//
//  BaseHelper.swift
//  Gululu
//
//  Created by Baker on 17/8/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class BaseHelper: NSObject {
    
    static let base_share = BaseHelper()
    var pet_story_view: PetStoryVC?
    
    func saveInfo(_ object : NSObject?, saveKey : String?)  {
        if object == nil {
            print("array is nil")
            return
        }
        if saveKey == "" || saveKey == nil{
            print("key is nil")
        }
        if activeChildID == "" {
            print("child id nil")
        }
        let saveKey = activeChildID + saveKey!
        UserDefaults.standard.set(object, forKey: saveKey)
        UserDefaults.standard.synchronize()
    }
    
    func cancel_paly_view()  {
        if pet_story_view != nil{
            pet_story_view?.cancle_streamer()
            pet_story_view = nil
        }
    }
    
    

}
