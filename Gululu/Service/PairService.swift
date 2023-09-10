//
//  PairService.swift
//  Gululu
//
//  Created by baker on 2018/3/15.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import Foundation

class PairService: NSObject {
    
    static let share = ShareHelper()
    
    static func syncTimeZone(_ cloudCallback:@escaping (Bool)->Void) {
        let requets = GUHttpRequest()
        requets.setRequestConfig(.post,url:setTimeZoneUrl)
        requets.body["x_child_sn"] = activeChildID
        requets.body["local_time"] = BKDateTime.getLocalDateString(Date())
        requets.handleRequset(callback: { result in
            if result.boolValue{
                cloudCallback(true)
                return
            }
            if case .Error(let e) = result {
                DispatchQueue.main.async(execute: {
                    let error: NSError = e as NSError
                    var errorMsg: String = ""
                    if error.userInfo["description"] != nil {
                        errorMsg = error.userInfo["description"] as! String
                    }
                    if errorMsg == "" {
                        errorMsg = Localizaed("set time zone error")
                    }
                    BH_ERROR_LOG(errorMsg)
                })
            }
            cloudCallback(false)
        })
    }
}
