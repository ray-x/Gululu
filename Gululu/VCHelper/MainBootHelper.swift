//
//  MainBootHelper.swift
//  Gululu
//
//  Created by Baker on 17/2/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class MainBootHelper: NSObject {
    
    static let share = MainBootHelper()

    func removeShowBootVCKeyValue(_ childID : String?) {
        guard childID != nil else {
            return
        }
        let saveKey = childID! + bootSaveKey
        UserDefaults.standard.removeObject(forKey: saveKey)
    }
    
    func saveShowBootVCKey(_ childID : String?) {
        guard childID != nil else {
            return
        }
        let saveKey = childID! + bootSaveKey
        UserDefaults.standard.set("1", forKey: saveKey)
    }
    
    func readSaveShowBootVCKey(_ childID : String?) -> Bool {
        guard childID != nil else {
            return false
        }
        let saveKey = childID! + bootSaveKey
        let userdefaultValue : String? = UserDefaults.standard.object(forKey: saveKey) as! String?
        if userdefaultValue == nil{
            return true
        }
        if userdefaultValue == "1"{
            return false
        }
        return true
    }
}
