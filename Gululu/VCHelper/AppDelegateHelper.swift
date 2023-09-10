//
//  AppDelegateHelper.swift
//  Gululu
//
//  Created by Baker on 17/4/5.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import Reachability

class AppDelegateHelper: NSObject {
    
    static let share = AppDelegateHelper()
    
    var bgTask: UIBackgroundTaskIdentifier! = nil
    var bgTimer: Timer! = nil
    private var boolGetNoti : Bool = false
    private var landScape : Bool = false
    let reachability = Reachability()!

    func isLandScape() -> Bool {
        return landScape
    }
    
    func setmyBoolGetNoti(_ trueOrFalse : Bool) {
        boolGetNoti = trueOrFalse
    }
    
    func isBoolGetNoti() -> Bool {
        return boolGetNoti
    }
    
    func setmylandScape(_ trueOrFalse : Bool) {
        landScape = trueOrFalse
    }
    
    func checkCurrentSSIDNeedShowBanner() -> Bool {
        if !boolGetNoti{
            if PairCupHelper.share.isConnetGululuAP() {
                setmyBoolGetNoti(true)
                return true
            }
        }
        return false
    }
    
    func readIsFirstAutoShowVideoViewValue() -> Bool{
        let value : Bool? = UserDefaults.standard.bool(forKey: isEnterTutoiesView)
        if value == nil{
            return false
        }
        return value!
    }
    
    func saveIsFirstAutoShowVideoViewValue(_ result : Bool) {
        UserDefaults.standard.set(result, forKey: isEnterTutoiesView)
        UserDefaults.standard.synchronize()
    }
    
    func readIsFirstInstallAndPairedValue() -> Bool {
        let value : Bool? = UserDefaults.standard.bool(forKey: isFirstEnterMain)
        if value == nil{
            return false
        }
        return value!
    }
    
    func saveIsFirstInstallAndPairedValue(_ result : Bool) {
        UserDefaults.standard.set(result, forKey: isFirstEnterMain)
        UserDefaults.standard.synchronize()
    }
    
   
    
}
