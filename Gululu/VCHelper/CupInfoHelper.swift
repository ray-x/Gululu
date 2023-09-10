//
//  CupInfoHelper.swift
//  Gululu
//
//  Created by Baker on 17/5/4.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class CupInfoHelper: BaseHelper {
    
    static let share = CupInfoHelper()
        
    var cupConnectStatus : Bool = true
    
    var cupConnectOvertime : Int = 0
    
    var syncTime = "1 min"
    
    var cupConnectTimeLastThreeDays : Bool = false
    
    var alterViewTag : Int = 0
    
    func checkCupConnectStatues() {
        if !Common.checkInternetConnection() {
            readDicFormDefault()
            return
        }
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url: getCupStatusUrl(GCup.share.readCupIDFromDB()))
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let status : String? = dic["status"] as? String
                if status == "OK"{
                    self.handleDicFormNet(dic)
                    self.saveInfo(dic, saveKey: cupInfoStatusDickey)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: cupStatusNoticationName), object: nil)
                    }
                }else{
                    self.readDicFormDefault()
                }
            }else{
                self.readDicFormDefault()
            }
        })
    }
    
    func readDicFormDefault() {
        guard activeChildID != "" else {
            handleSyncTime(nil)
            return
        }
        let key = cupInfoStatusDickey + activeChildID
        let dic : NSDictionary? = UserDefaults.standard.object(forKey: key) as? NSDictionary
        if dic != nil{
            handleDicFormNet(dic)
        }
    }
    
    func handleDicFormNet(_ dic : NSDictionary?)  {
        guard dic != nil else {
            return
        }
        if dic!["cup_connect_overtime"] != nil {
            self.handleCupConnectStatus(dic!["cup_connect_overtime"] as? Int)
        }
        if dic!["last_sync_time"] != nil{
            self.handleSyncTime(dic!["last_sync_time"] as? Int)
        }
    }
    
    func handleCupConnectStatus(_ overtime : Int?)  {
        if overtime != nil {
            cupConnectOvertime = overtime!
        }
    }
    
    func handleSyncTime(_ syncTimeNet : Int?) {
        if syncTimeNet == nil{
            syncTime = "1" + " " + Localizaed("min")
            return
        }
        
        let timeZoneMy: NSTimeZone = NSTimeZone.system as NSTimeZone
        let send:Int = timeZoneMy.secondsFromGMT
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let interValValue : Int = timeStamp - syncTimeNet! - send
        
        if interValValue >= cupConnectOvertime{
            cupConnectStatus = false
        }else{
            cupConnectStatus = true
        }
        
        if interValValue <= 119{
            saveClickRedSign(false)
            syncTime = "1" + " " + Localizaed("min")
        }else if interValValue > 119 && interValValue < 3600 {
            saveClickRedSign(false)
            let mins = Int(interValValue/60)
            syncTime = String(mins) + " " + Localizaed("mins")
        }else if interValValue >= 3600 && interValValue < 3600*2 {
            saveClickRedSign(false)
            let hours = Int(interValValue/3600)
            syncTime = String(hours) + " " + Localizaed("hr")
        }else if interValValue >= 3600*2 && interValValue < 3600*24 {
            saveClickRedSign(false)
            let hours = Int(interValValue/3600)
            syncTime = String(hours) + " " + Localizaed("hrs")
        }else if interValValue >= 3600*24 && interValValue < 3600*24*2 {
            saveClickRedSign(false)
            let hours = Int(interValValue/3600/24)
            syncTime = String(hours) + " " + Localizaed("day")
        }else {
            let days = Int(interValValue/3600/24)
            if days > 3{
                if readClickRedSgin(){
                    cupConnectTimeLastThreeDays = false
                }else{
                    cupConnectTimeLastThreeDays = true
                }
            }else{
                saveClickRedSign(false)
            }
            syncTime = String(days) + " " + Localizaed("days")
        }
    }
    
    func saveClickRedSign(_ result : Bool) {
        guard activeChildID != "" else {
            return
        }
        cupConnectTimeLastThreeDays = false
        let key = cupThreeDayClickRedSignKey + activeChildID
        UserDefaults.standard.set(result, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func readClickRedSgin() -> Bool {
        guard activeChildID != "" else {
            return true
        }
        let key = cupThreeDayClickRedSignKey + activeChildID
        return UserDefaults.standard.bool(forKey: key)
    }
    
}
