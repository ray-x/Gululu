//
//  GChildRequest.swift
//  Gululu
//
//  Created by baker on 2017/11/24.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GChildRequest: NSObject {

}

extension GChild{
    
    func getChildList(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void) {
        let child : Children?
        let childListFromData = readChildListFromDB()
        if childListFromData?.count == 0 || childListFromData == nil{
            child = createObject(Children.self)
        }else{
            child = childListFromData?.first
        }
        guard child != nil else {
            return
        }
        child!.update(.fetchAll, uiCallback: { result in
            if self.isHaveChild(){
                let fetchedChild = self.readChildListFromDB()
                GUser.share.updateChildList()
                fetchedChild?.forEach({ child in
                    GCup.share.refleshChildCup(child: child)
                })
            }
            cloudCallback(result)
        })
    }
    
    func getHabitex(_ cloudCallback:@escaping (Int) -> Void) {
        if !Common.checkInternetConnection() {
            let defauletValue = readHabitIndex()
            cloudCallback(defauletValue)
            return
        }
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:gethabitScoreUrl)
        requets.header["x_child_sn"] = activeChildID
        requets.handleRequset(callback: { result in
            if result.boolValue {
                let idx = result.value!["score"] as? Int
                if idx != nil {
                    cloudCallback(self.checkHabitResult(result: idx!))
                }
            } else {
                let defauletValue = self.readHabitIndex()
                cloudCallback(defauletValue)
            }
        })
    }
    
    func updateActiveChildInfo(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void){
        
        if !Common.checkInternetConnection() {
            return
        }
        guard activeChildID != "" else {
            return
        }
        let child : Children? = createObject(Children.self, objectID:activeChildID)
        guard child?.childID != nil else {
            return
        }
        child?.update(.fetch, uiCallback: { result in
            GCup.share.refleshChildCup(child: GUser.share.activeChild)
            if result.boolValue {
                cloudCallback(result)
            }else{
                print("update error")
            }
            
        })
    }
    
    func getDayDrinkLog(_ updateWaterDay: @escaping () -> ()) {
        if !Common.checkInternetConnection(){
            readDrinkDayData()
            updateWaterDay()
            return
        }
        let dayDateUnix = BKDateTime.getDayUnix()
        let weekDayUnix = dayDateUnix-Double(6*24*3600)
        
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:getDrinkLogsUrl)
        requets.header["x_child_sn"] = activeChildID
        requets.header["query_type"] = "day"
        requets.header["start_ts"] = String(weekDayUnix)
        requets.handleRequset(callback: { success in
            var waterDay=[Int](repeating: 0, count: 7)
            if success.boolValue {
                let data=success.value!["drinking"] as? [AnyObject]
                if (data == nil ||  data?.count==0 ) {
                    print("no drink data")
                }
                if data!.count>0{
                    for item in data! {
                        var barIdx=(item["day"] as! Int)
                        barIdx = barIdx < waterDay.count ? barIdx : waterDay.count-1
                        if barIdx < waterDay.count {
                            waterDay[barIdx]=item["vol"] as! Int
                        }
                    }
                }else{
                    //drinkData=0
                    for idx in 0..<waterDay.count {
                        waterDay[idx]=0
                    }
                }
                self.drinkWaterDayArray = waterDay
                self.saveDrinkDayData()
                updateWaterDay()
            }else{
                self.readDrinkDayData()
                updateWaterDay()
            }
            
        })
    }
    
    func getHourDrinkLog( _ updateView: @escaping (Int) -> (Void) ) {
        if !Common.checkInternetConnection(){
            updateView(self.readDrinkHourData())
            return
        }
        lastDrinkUpdate = Date()
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:getDrinkLogsUrl)
        requets.header["x_child_sn"] = activeChildID
        requets.header["query_type"] = "hour"
        requets.header["start_ts"] = String(BKDateTime.getDayUnix())
        requets.handleRequset(callback: { result in
            switch result {
            case .Error:
                updateView(self.readDrinkHourData())
            case .Success:
                var waterHour=[Int](repeating: 0, count: 7)
                
                var water2Day = 0
                for idx in 0 ..< waterHour.count {
                    waterHour[idx] = 0
                }
                let data = result.value!["drinking"] as? [AnyObject]
                if (data == nil || data?.count == 0){
                    print("no water data")
                    waterHour = [0,0,0,0,0,0,0]
                    water2Day = 0
                } else if data?.count > 0 {
                    water2Day = 0
                    for item in data! {
                        water2Day += (item["vol"] as? Int ) ?? 0
                        let drinkHour = (item["hour"] as? Int) ?? 0
                        if drinkHour >= 7 && drinkHour < 21 {
                            let barIdx = (drinkHour - 7) / 2
                            waterHour[barIdx]  +=  (item["vol"] as? Int) ?? 0
                        }
                    }
                } else {
                    water2Day = 0
                    for idx in 0 ..< waterHour.count {
                        waterHour[idx] = 0
                    }
                }
                self.drinkWaterHourArray = waterHour
                self.saveDrinkHourData(water2Day)
                updateView(water2Day)
            }
            
        })
    }
}
