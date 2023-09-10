//
//  GSleepHelper.swift
//  Gululu
//
//  Created by Baker on 17/3/14.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GSleepHelper: NSObject {
    
    static let share = GSleepHelper()

    var dateStrDic : NSMutableDictionary = ["Sleep":"21:00","Wake":"07:00"]
    var sleepTime : WakeSleep?
    
    func setSleepTimeValue() {
        if !isVailedSleepTime(){
            return
        }
        for (key , value) in dateStrDic{
            if key as? String == "Sleep"{
                guard (value as! String).count == 5 else {
                    return
                }
                let hourValue = (value as! NSString).substring(with: NSRange(location: 0, length: 2))
                let minValue = (value as! NSString).substring(with: NSRange(location: 3, length: 2))
                sleepTime!.sleepHr = NSNumber(value: Int(hourValue)! as Int)
                sleepTime!.sleepMin = NSNumber(value: Int(minValue)! as Int)
            }else if key as? String == "Wake"{
                guard (value as! String).count == 5 else {
                    return
                }
                let hourValue = (value as! NSString).substring(with: NSRange(location: 0, length: 2))
                let minValue = (value as! NSString).substring(with: NSRange(location: 3, length: 2))
                sleepTime!.wakeHr = NSNumber(value: Int(hourValue)! as Int)
                sleepTime!.wakeMin = NSNumber(value: Int(minValue)! as Int)
            }
        }
    }
    
    func isVailedSleepTime() -> Bool {
        if sleepTime == nil || sleepTime?.wakeID == nil {
            return false
        }else{
            return true
        }
    }
    
    func setDateStrDic() {
        if !isVailedSleepTime(){
            return
        }
        let wakeVaule = String(format:"%02d:%02d",(sleepTime!.wakeHr!.intValue),(sleepTime!.wakeMin!.intValue))
        let sleepValue = String(format:"%02d:%02d",(sleepTime!.sleepHr!.intValue),(sleepTime!.sleepMin!.intValue))
        dateStrDic.setValue(sleepValue, forKey: "Sleep")
        dateStrDic.setValue(wakeVaule, forKey: "Wake")
    }
    
    func setSwitchOnSleep(_ isOn : Bool)  {
        if !isVailedSleepTime(){
            return
        }
        sleepTime!.sleepEn = isOn as NSNumber?
    }
    
    func getKeyAccoredTimeValue(_ timeValue : Float) -> String {
        
        if 5.0 <= timeValue && timeValue <= 11.0 {
            return "Wake"
        }else if 19.0 <= timeValue && timeValue <= 23.0 {
            return "Sleep"
        }else{
            return "Wake"
        }
    }
    
    func getLabelTimeStrValue(_ label: UILabel) -> String {
        guard label.text != nil else {
            return "19:00"
        }
        let strCount : Int = (label.text?.count)!
        if Common.checkPreferredLanguagesIsEn(){
            if strCount != 15 {
                return "19:00"
            }
        }else{
            if strCount != 12 {
                return "19:00"
            }
        }
        
        let labelText = label.text!
        let hourStr = (labelText as NSString).substring(with: NSRange(location: strCount-5, length: 2))
        let minStr = (labelText as NSString).substring(with: NSRange(location: strCount-2, length: 2))
        return "\(hourStr):\(minStr)"
    }
    
    func setDataDicValueFormKey(_ value : String, timeValue : Float) {
        let key = getKeyAccoredTimeValue(timeValue)
        dateStrDic.setValue(value, forKey: key)
    }
    
    func updateSleepTime(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void) {
        if !isVailedSleepTime(){
            return
        }
        sleepTime!.update(.update, uiCallback:{ result in
            cloudCallback(result)
        })
    }
    
    func getSleepTime(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void) {
        readSleepTimeFromDB()
        if sleepTime == nil {
            sleepTime =  createObject(WakeSleep.self)!
        }
        sleepTime?.childID = activeChildID
        sleepTime?.update(.fetch, uiCallback: { result in
            self.setDateStrDic()
            cloudCallback(result)
        })
    }
    
    func readSleepTimeFromDB() {
        let sleepTimedb : WakeSleep? = createObject(WakeSleep.self, objectID: activeChildID)
        guard sleepTimedb != nil else {
            return
        }
        sleepTime = sleepTimedb
    }
    
}
