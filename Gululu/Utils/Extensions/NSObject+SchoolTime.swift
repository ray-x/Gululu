//
//  NSObject+SchoolTime.swift
//  Gululu
//
//  Created by Ray Xu on 24/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

extension NSObject {
    func convert2SchoolTime(_ dict:NSDictionary) {
        /* expected result:
         {
         "status": "OK",
         "configs": [
         {
         "end_min": 45,
         "start_min": 0,
         "end_hour": 18,
         "config_enable": "1",
         "start_hour": 13,
         "type": "school",
         "id": 73,
         "weekdays": "1,2,3,4"
         },
         {
         "end_min": 30,
         "start_min": 30,
         "end_hour": 11,
         "config_enable": "1",
         "start_hour": 9,
         "type": "school",
         "id": 74,
         "weekdays": "1,2,3"
         }
         ]
         }
         */
        
        var id = dict["x_child_sn"] as? String
        if id == nil
        {
            id = activeChildID
            print("school time error")
            return
        }
        else
        {
            (self as! SchoolTime).childID = id
        }
        if (self as? NSManagedObject)?.managedObjectContext == nil {
            backgroundMoc!.insert(self as! NSManagedObject)
        }
        let configs = dict["configs"] as? NSArray
        if configs != nil && configs?.count >= 2 {
            let config = configs![0] as! NSDictionary
            let config2 = configs![1] as! NSDictionary
            let schoolEnStr = config["config_enable"] as! String
            let schoolEn = Int(schoolEnStr)
            if config["type"] as! String == "school"
            {
                (self as! SchoolTime).morningFromHr  = config["start_hour"] as? NSNumber
                (self as! SchoolTime).morningFromMin = config["start_min"] as? NSNumber
                (self as! SchoolTime).morningToHr    = config["end_hour"] as? NSNumber
                (self as! SchoolTime).morningToMin   = config["end_min"] as? NSNumber
                (self as! SchoolTime).morningID      = config["id"] as? NSNumber
                
                (self as! SchoolTime).noonID         = config2["id"] as? NSNumber
                (self as! SchoolTime).noonToHr       = config2["end_hour"] as? NSNumber
                (self as! SchoolTime).noonToMin      = config2["end_min"] as? NSNumber
                (self as! SchoolTime).noonFromHr     = config2["start_hour"] as? NSNumber
                (self as! SchoolTime).noonFromMin    = config2["start_min"] as? NSNumber
                (self as! SchoolTime).childID        = id
                (self as! SchoolTime).schoolModeEn   = schoolEn as NSNumber? 
            }
        }
    }

    
    func convert2SleepTime(_ dict:NSDictionary) {
        /* expected result:
         {
         "status": "OK",
         "configs": [
         {
         "end_min": 45,
         "start_min": 0,
         "end_hour": 18,
         "config_enable": "1",
         "start_hour": 13,
         "type": "school",
         "id": 73,
         "weekdays": "1,2,3,4"
         },
         {
         "end_min": 30,
         "start_min": 30,
         "end_hour": 11,
         "config_enable": "1",
         "start_hour": 9,
         "type": "school",
         "id": 74,
         "weekdays": "1,2,3"
         }
         ]
         }
         */
        
        let id = dict["x_child_sn"] as? String
        if id == nil
        {
            print("school time error")
            return
        }
        else
        {
            (self as! WakeSleep).childID = id
        }
        if (self as? NSManagedObject)?.managedObjectContext == nil {
            backgroundMoc!.insert(self as! NSManagedObject)
        }

        let configs = dict["configs"] as? NSArray
        if configs != nil && configs?.count >= 1 {
            configs!.forEach ( { (config) in
                let cfg=config as! NSDictionary
                if cfg["type"] as! String == "sleep"
                {
                    let schoolEnStr = cfg["config_enable"] as! String
                    (self as! WakeSleep).sleepEn   = Int(schoolEnStr) as NSNumber?
                    (self as! WakeSleep).sleepHr   = cfg["start_hour"] as? NSNumber
                    (self as! WakeSleep).sleepMin  = cfg["start_min"] as? NSNumber
                    (self as! WakeSleep).wakeHr    = cfg["end_hour"] as? NSNumber
                    (self as! WakeSleep).wakeMin   = cfg["end_min"] as? NSNumber
                    (self as! WakeSleep).wakeID    = cfg["id"] as? NSNumber
                    (self as! WakeSleep).childID   = id
                }
            })
        }
    }
    
    func fillinSleepTimeDict()->[String:AnyObject]{
        let sleep=(self as! WakeSleep)
        if sleep.sleepEn == nil{
            sleep.sleepEn = 0
        }
        if sleep.childID == nil{
            sleep.childID = "0"
        }
        let sleepconfig = [["start_hour":sleep.sleepHr!, "start_min":sleep.sleepMin!, "end_hour":sleep.wakeHr!, "end_min":sleep.wakeMin!, "config_enable":Bool(truncating: sleep.sleepEn!) ,  "weekdays":"0,1,2,3,4,5,6", "id":sleep.wakeID!]]
        let sleepTime=["x_child_sn":sleep.childID!,"type":"sleep", "configs":sleepconfig] as [String : Any]
        return sleepTime as [String : AnyObject]
    }
    
    func fillinSchoolDict()->[String:AnyObject] {
        let schoolInfo=(self as! SchoolTime)
        if schoolInfo.schoolModeEn == nil{
            schoolInfo.schoolModeEn = 0
        }
        if schoolInfo.childID == nil{
            schoolInfo.childID = "0"
        }
        
        if schoolInfo.noonID == nil {
            schoolInfo.noonID = NSNumber(value: 0)
        }
        
        if schoolInfo.morningID == nil {
            schoolInfo.morningID = NSNumber(value: 0)
        }

        let sleepconfig = [["start_hour":schoolInfo.morningFromHr!,
                            "start_min":schoolInfo.morningFromMin!,
                            "end_hour":schoolInfo.morningToHr!,
                            "end_min":schoolInfo.morningToMin!,
                            "id":schoolInfo.morningID!,
                            "config_enable": Bool(truncating: schoolInfo.schoolModeEn!),
                            "weekdays":"1,2,3,4,5"],
                           ["start_hour":schoolInfo.noonFromHr!,
                            "start_min":schoolInfo.noonFromMin!,
                            "end_hour":schoolInfo.noonToHr!,
                            "end_min":schoolInfo.noonToMin!,
                            "id":schoolInfo.noonID!,
                            "config_enable": Bool(truncating: schoolInfo.schoolModeEn!),
                            "weekdays":"1,2,3,4,5"]]
        
        let schoolTime=["x_child_sn":schoolInfo.childID!,"type":"school", "configs":sleepconfig] as [String : Any]
        return schoolTime as [String:AnyObject]
    }

}
