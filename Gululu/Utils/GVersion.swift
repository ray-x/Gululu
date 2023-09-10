//
//  GHelper.swift
//  Gululu
//
//  Created by Baker on 17/2/23.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GVersion: NSObject {
    static let share = GVersion()
    var isForceUpdate : Bool = false
    var isUpdate : Bool = false
    var msgTitle : String = ""
    var detail : String = ""
    var newAppVerSion : String = ""
    let appVer = AppData.share.App_version
    
    func getApiVersion(_ cloudCallback:@escaping () ->Void) {
        cloudObj().getAPIVersion { (result) in
            if !result.boolValue {
                print("error getting serverAPI version")
            } else {
                let verInfo = result.value!["ios_app"] as? [String: String]
                if verInfo != nil {
                    self.handle_version_info(verInfo!)
                }
            }
            cloudCallback()
        }
    }
    
    func handle_version_info(_ verInfo:[String : String])  {
        let supVer = verInfo["new_app_version"] as String!
        let reqVer = verInfo["api_required_app_version"] as String!
        self.newAppVerSion = supVer!
        if self.compareVersion(reqVer!, version2: self.appVer!) > 0 {
            self.msgTitle = verInfo["api_required_app_title"]!
            self.detail = verInfo["api_required_app_msg"]!
            self.isForceUpdate = true
            self.isUpdate = false
        } else {
            if self.compareVersion(supVer!, version2: self.appVer!) <= 0{
                self.isUpdate = false
                self.isForceUpdate = false
                return
            }
            self.msgTitle = verInfo["new_app_title"]!
            self.detail = verInfo["new_app_msg"]!
            self.isUpdate = true
            self.isForceUpdate = false
            
            let userDefaults = UserDefaults.standard
            let lastTipVer = userDefaults.object(forKey: supportTipVersion) as? String
            
            if lastTipVer != nil && self.compareVersion(supVer!, version2: lastTipVer!) < 1 {
                return
            }
            
            userDefaults.setValue(supVer, forKey: supportTipVersion)
            userDefaults.synchronize()
        }
    }
    
    func compareVersion(_ version1: String, version2: String) -> Int {
        if version1 == version2 {
            return 0
        }
        if version1 == "" {
            return -1
        }
        if version2 == "" {
            return 1
        }
        
        let Arr1 = version1.split{$0 == "."}.map(String.init)
        let Arr2 = version2.split{$0 == "."}.map(String.init)
        for (idx,_) in Arr1.enumerated() {
            if Arr1[idx] == Arr2[idx] {
                continue
            }
            if Int(Arr1[idx]) > Int(Arr2[idx]) {
                return 1
            } else {
                return -1
            }
        }
        return 0
    }
    
}
