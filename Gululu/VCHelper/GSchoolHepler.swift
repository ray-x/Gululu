//
//  GSchoolHepler.swift
//  Gululu
//
//  Created by Baker on 17/3/14.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GSchoolHepler: NSObject {

    static let share = GSchoolHepler()
    
    var dateStrDic : NSMutableDictionary = ["0":"06:00","1":"11:00","2":"13:00","3":"20:00"]
    var schoolTime : SchoolTime?
    
    func setSchoolTimeValue() {
        if schoolTime == nil{
            return
        }
        for i in 0...3 {
            let dateStrOrigin : String? = dateStrDic.object(forKey: "\(i)") as? String
            if dateStrOrigin != nil{
                let hourValue = (dateStrOrigin! as NSString).substring(with: NSRange(location: 0, length: 2))
                let minValue = (dateStrOrigin! as NSString).substring(with: NSRange(location: 3, length: 2))
                if i == 0{
                    schoolTime?.morningFromHr = NSNumber(value: Int(hourValue)! as Int)
                    schoolTime?.morningFromMin = NSNumber(value: Int(minValue)! as Int)
                }else if i == 1{
                    schoolTime?.morningToHr = NSNumber(value: Int(hourValue)! as Int)
                    schoolTime?.morningToMin = NSNumber(value: Int(minValue)! as Int)
                }else if i == 2{
                    schoolTime?.noonFromHr = NSNumber(value: Int(hourValue)! as Int)
                    schoolTime?.noonFromMin = NSNumber(value: Int(minValue)! as Int)
                }else if i == 3{
                    schoolTime?.noonToHr = NSNumber(value: Int(hourValue)! as Int)
                    schoolTime?.noonToMin = NSNumber(value: Int(minValue)! as Int)
                }
            }
        }
    }
    
    func setDateSetDicFromSchool() {
        guard schoolTime?.schoolModeEn != nil else {
            return
        }
        let value1 : String = String(format:"%02d:%02d",(schoolTime?.morningFromHr?.intValue)!,(schoolTime?.morningFromMin?.intValue)!)
        let value2 : String = String(format:"%02d:%02d",(schoolTime?.morningToHr?.intValue)!,(schoolTime?.morningToMin?.intValue)!)
        let value3 : String = String(format:"%02d:%02d",(schoolTime?.noonFromHr?.intValue)!,(schoolTime?.noonFromMin?.intValue)!)
        let value4 : String = String(format:"%02d:%02d",(schoolTime?.noonToHr?.intValue)!,(schoolTime?.noonToMin?.intValue)!)
        dateStrDic.setValue(value1, forKey:"0")
        dateStrDic.setValue(value2, forKey:"1")
        dateStrDic.setValue(value3, forKey:"2")
        dateStrDic.setValue(value4, forKey:"3")
    }
    
    func setSwitchOnshcool(_ isOn : Bool)  {
        guard schoolTime != nil else {
            return
        }
        schoolTime!.schoolModeEn = isOn as NSNumber?
    }
    
    func updateSchoolTime(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void) {
        guard schoolTime != nil else {
            return
        }
        schoolTime?.update(.update, uiCallback:{ result in
            cloudCallback(result)
        })
    }
    
    func setKeyTotheDateStrDic(_ key : String, timeValue : String) {
        dateStrDic.setValue(timeValue, forKey: key)
        if key == "1"{
            let value2 : String = dateStrDic.object(forKey: "2") as! String
            let timeIntValue = timeValue.replacingOccurrences(of: ":", with: "")
            let valueInt2 = value2.replacingOccurrences(of: ":", with: "")

            if Int(timeIntValue) > Int(valueInt2){
                dateStrDic.setValue(timeValue, forKey: "2")
            }
        }
    }
    
    func getSchoolTime(_ cloudCallback:@escaping (Result<NSDictionary>) -> Void) {
        readSchoolTimeFromDB()
        
        if schoolTime == nil {
            schoolTime = createObject(SchoolTime.self)!
        }
        
        schoolTime?.childID = activeChildID
        schoolTime?.update(.fetch, uiCallback: { result in
            self.setDateSetDicFromSchool()
            cloudCallback(result)
        })
    }
    
    func readSchoolTimeFromDB(){
        let schoolTimedb : SchoolTime? = createObject(SchoolTime.self, objectID: activeChildID)
        guard schoolTimedb != nil else {
            return
        }
        schoolTime = schoolTimedb
    }

}
