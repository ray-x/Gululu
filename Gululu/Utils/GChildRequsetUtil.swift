//
//  GChildRequsetUtil.swift
//  Gululu
//
//  Created by Baker on 2017/10/12.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GChildRequsetUtil: NSObject {
    
    static func updateChilren(_ cloudCallback:@escaping (Bool)->Void){
        
        let child:Children? = createObject(Children.self, objectID: activeChildID)
        guard child != nil else {
            cloudCallback(false)
            return
        }
        child!.childName = GUser.share.activeChild?.childName
        child!.birthday = GUser.share.activeChild?.birthday
        child?.water_rate = GUser.share.activeChild?.water_rate
        child?.unit = GUser.share.activeChild?.unit
        if child?.unit == "lbs" {
            child?.weightLbs = GUser.share.workingChild?.weightLbs
            child?.weight = nil
        }else{
            child?.weightLbs = nil
            child?.weight = GUser.share.workingChild?.weight
        }
        child!.update((.update), uiCallback: { result in
            DispatchQueue.main.async {
                if result.boolValue{
                    cloudCallback(true)
                }else{
                    cloudCallback(false)
                }
            }
        })
    }
    
    
}
