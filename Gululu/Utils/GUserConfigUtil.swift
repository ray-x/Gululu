//
//  GUserConfigUtil.swift
//  Gululu
//
//  Created by Baker on 2017/10/9.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GUserConfigUtil: NSObject {
    
    let CHANGE_PET = "CHILD_CHANGE_PET"
    let VAULT_SYNC_S3 = "VAULT_SYNC_S3"
    let ADD_NEXT_PET = "CHILD_ADD_NEXT_PET"
    let CHECK_PHONE_CODE = "CHECK_PHONE_CODE"
    let ADD_FRIEND_BY_APP = "ADD_FRIEND_BY_APP"
    let PET_STORY_PLAY = "APP_AUDIO_STORY"
    
    static let share = GUserConfigUtil()
    var feature_off = NSArray()
    var feature_on =  NSArray()
    var server_ok: Bool = false
    
    func checkout_health_in_feature_config(_ cloudCallback:@escaping (Bool)->Void){
        let requets = GUHttpRequest()
        requets.lastApiString = health_feature_url
        requets.httpType = .get
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic = result.value
                GUserConfigUtil.share.feature_off = dic?.object(forKey: "features_off") as! NSArray
                GUserConfigUtil.share.feature_on = dic?.object(forKey: "features_on") as! NSArray
                GUserConfigUtil.share.server_ok = true
                cloudCallback(true)
            }else{
                GUserConfigUtil.share.server_ok = false
                cloudCallback(false)
            }
        })
    }
    
    func checkout_health_in_feature_config_no_callback(){
        let requets = GUHttpRequest()
        requets.lastApiString = health_feature_url
        requets.httpType = .get
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic = result.value
                GUserConfigUtil.share.feature_off = dic?.object(forKey: "features_off") as! NSArray
                GUserConfigUtil.share.feature_on = dic?.object(forKey: "features_on") as! NSArray
                GUserConfigUtil.share.server_ok = true
            }else{
                GUserConfigUtil.share.server_ok = false
            }
        })
    }
    
    func checkout_features_config(_ feature:String?) -> Bool {
        if !isValidString(feature){
            return false
        }
        
        if isValidArray(GUserConfigUtil.share.feature_on) == false{
            return false
        }
        
        if GUserConfigUtil.share.feature_on.contains(feature ?? "DEFAULT_VALUE"){
            return true
        }else{
            return false
        }
    }
    
    func checkout_change_pet_feature() -> Bool {
        return GUserConfigUtil.share.checkout_features_config(CHANGE_PET)
    }
    
    func checkout_add_next_pet_feature() -> Bool {
        return GUserConfigUtil.share.checkout_features_config(ADD_NEXT_PET)
    }
    
    func checkout_check_phone_code() -> Bool {
        return GUserConfigUtil.share.checkout_features_config(CHECK_PHONE_CODE)
    }
    
    func checkout_add_frined() -> Bool {
        return GUserConfigUtil.share.checkout_features_config(ADD_FRIEND_BY_APP)
    }
    
    func checkout_pet_story_feature() -> Bool {
        return GUserConfigUtil.share.checkout_features_config(PET_STORY_PLAY)
    }
    
}
