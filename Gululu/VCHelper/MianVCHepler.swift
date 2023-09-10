//
//  MianVCHepler.swift
//  Gululu
//
//  Created by Baker on 17/3/15.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

enum ShowEggOrPet {
    case egg,pet,sync,defaultNoMaskView
}

enum PetModel {
    case changePet,syncPet,defaultModel
}

enum SuccessHander : Int{
    case settingHander
    case cupinfoHander
    case childInfoHander
    case helpshiftHander
    case defaultHander
    case addChildHander
    case helpshiftBoxHander
}

class MianVCHepler: NSObject {
    
    static let share = MianVCHepler()
    
    var lockVcContext = 0

    var showEggOrPet : ShowEggOrPet   = .defaultNoMaskView
    var petModel : PetModel = .defaultModel
    var successHander : SuccessHander = .defaultHander

    var settingDisplayed        = false
    var childrenDisplayed       = false
    var drinkBarChartDisplayed  = false
    var addBottleButtonIsAnimation = false
    
    var childrenWidth: CGFloat = SCREEN_WIDTH/1.44
    var settingWidth: CGFloat = SCREEN_WIDTH/1.44
    var barViewheight: CGFloat = SCREEN_HEIGHT/2.22
    

    func saveNewInboxMessage() {
        UserDefaults.standard.set(true, forKey: inboxShouldShowNewRedSignKey)
        UserDefaults.standard.synchronize()
    }
    
    func saveReadNewInBoxMessage() {
        UserDefaults.standard.set(false, forKey: inboxShouldShowNewRedSignKey)
        UserDefaults.standard.synchronize()
    }
    
    func isShouldShowNewRedSign() -> Bool {
        var newInBoxMessageBool : Bool? = UserDefaults.standard.object(forKey: inboxShouldShowNewRedSignKey) as! Bool?
        if newInBoxMessageBool == nil{
            newInBoxMessageBool = false
        }
        return newInBoxMessageBool!
    }
    
    func isShowSetView() {
        
    }
    
    func save_click_pet_button(_ result: Bool) {
        let key1 = activeChildID + click_main_pet_button_key
        UserDefaults.standard.set(result, forKey: key1)
        UserDefaults.standard.synchronize()
    }
    
    func read_click_pet_button() -> Bool {
        let key1 = activeChildID + click_main_pet_button_key
        let result:Bool? = UserDefaults.standard.bool(forKey: key1)
        if result != nil {
            return result!
        }
        return false
    }
}
