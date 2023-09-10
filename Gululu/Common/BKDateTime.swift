//
//  DateTime.swift
//  Gululu
//
//  Created by Baker on 17/5/10.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class BKDateTime: NSObject {
    
    static let YearTimeStr = "yyyy"
    static let NormalTimeStr = "yyyy-MM-dd HH:mm:ss"
    static let ChinaNormalTimeStr = "yyyy年MM月dd日"
    static let MinAndSecondTimeStr = "mm:ss"
    static let ShortNormalTimeStr = "yyyy-MM-dd"

    private static func CreateDateFormat() -> DateFormatter
    {
        let formatter = DateFormatter()
        let local = Locale.init(identifier: Locale.preferredLanguages[0])
        formatter.locale = local
        return formatter;
    }
    
    private static func DateFormatStr(_ dateFormat:String?, date: Date?) -> String
    {
        guard dateFormat != nil ||  date != nil else {
            return ""
        }
        let dateformatter = CreateDateFormat()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: date!)
    }
    
    private static func DateFormatDate(_ dateFormat : String?, dateStr: String?) -> Date
    {
        guard dateFormat != nil ||  dateStr != nil else {
            return Date()
        }
        let dateformatter = CreateDateFormat()
        dateformatter.dateFormat = dateFormat
        return dateformatter.date(from: dateStr!)!
    }
    
    static func getDateStrFormDate(_ fromat: String, date: Date) -> String {
        return DateFormatStr(fromat, date: date)
    }
    
    static func getCurDateYear() -> String
    {
        return DateFormatStr(YearTimeStr, date: Date())
    }
    
    static func getLocalDateString(_ date: Date) -> String
    {
        return DateFormatStr(NormalTimeStr, date: date)
    }
    
    static func checkoutChristmasDay(_ now_date: Date?) -> Bool{
        guard now_date != nil else {
            return false
        }
        let cri_before = DateFormatDate(ShortNormalTimeStr, dateStr: "2017-12-22")
        let cri_after = DateFormatDate(ShortNormalTimeStr, dateStr: "2018-01-02")
        return ComPareData(now_date, cri_before, cri_after)
    }
    
    fileprivate static func ComPareData(_ now_date: Date?, _ cri_before: Date, _ cri_after: Date) -> Bool {
        if now_date!.compare(cri_before).rawValue >= 0 && now_date!.compare(cri_after).rawValue <= 0{
            return true
        }else{
            return false
        }
    }
    
    static func checkoutSpringFestvialDay(_ now_date: Date?) -> Bool{
        guard now_date != nil else {
            return false
        }
        let cri_before = DateFormatDate(ShortNormalTimeStr, dateStr: "22018-02-15")
        let cri_after = DateFormatDate(ShortNormalTimeStr, dateStr: "2018-02-22")
        return ComPareData(now_date, cri_before, cri_after)
    }
    
    static func getDayUnix () -> TimeInterval {
        let components=(Calendar.current as NSCalendar).components([.year ,.month, .day, .hour, .minute, .second, .weekday] , from: Date())
        let dateStr: String = String(format:"%d-%d-%d 00:00:00",components.year!,components.month!,components.day!)
        let tsDayDate = DateFormatDate(NormalTimeStr, dateStr: dateStr);
        return tsDayDate.timeIntervalSince1970
    }

    
    static func dateToTimeStamp(_ date:Date?) -> Int {
        var defaultdate = date
        if defaultdate == nil{
            defaultdate = Date()
        }
        let dateStamp:TimeInterval = defaultdate!.timeIntervalSince1970
        return Int(dateStamp)
    }
    
    static func timeStampToDate(_ timeStamp:Int?) -> Date {
        if timeStamp == nil{
            return Date()
        }
        return Date(timeIntervalSince1970: TimeInterval(timeStamp!))
    }
    
    static func timer_form_interval(_ interVer: TimeInterval?) -> String {
        if interVer == nil {
            return "00:00"
        }
        let date = Date(timeIntervalSince1970: interVer!)
        
        return DateFormatStr(MinAndSecondTimeStr, date: date)
    }
    
    static func stringToTimeStamp(_ stringTime:String)->String {
        let date = DateFormatDate(ChinaNormalTimeStr, dateStr: stringTime);
    
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        
        let dateSt:Int = Int(dateStamp)
        
        return String(dateSt)
    }
    
    static func timeStampToString(_ timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return DateFormatStr(ChinaNormalTimeStr, date:  date as Date)
    }
    
    static func getNowTimeIntervel() -> Int {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        let timeZoneMy: NSTimeZone = NSTimeZone.system as NSTimeZone
        let send: Int = timeZoneMy.secondsFromGMT
        return timeStamp - send
    }

    
    static func getDateFromStr(_ format:String, dateStr:String) -> Date {
        guard format.count == dateStr.count else{
            return Date()
        }
        return DateFormatDate(format, dateStr: dateStr)
    }
    
    static func getAge(birthdayStr:String) ->(Int,String){
        let date = DateFormatDate(ShortNormalTimeStr, dateStr: birthdayStr)
        let zone = TimeZone.current
        let interval = Double(zone.secondsFromGMT(for: date))
        let lastDate : Date = date.addingTimeInterval(interval)
        return ageWithDateOfBirth(date: lastDate)
    }
    
    static func ageWithDateOfBirth(date: Date) -> (Int,String) {
        let calendar = Calendar.current
        var dateCalendar = (calendar as NSCalendar).components([.second, .minute, .hour, .day , .month , .year], from: date)

        var currentCalendar = (calendar as NSCalendar).components([.second, .minute, .hour, .day , .month , .year], from: Date())
        
        let age = currentCalendar.year! - dateCalendar.year!
        if age >= 1{
            return (age, Localizaed("y.o"))
        }else{
            let mouth = currentCalendar.month! - dateCalendar.month!
            if mouth >= 1{
                return (mouth, Localizaed("mouth"))
            }else{
                return (1, Localizaed("mouth"))
            }
        }
    }
    
    static func getDateArray() -> NSArray
    {
        let dateArray = NSMutableArray()
        let strArray = NSMutableArray()
        let currentDate = Date()
        
        for i in (0 ... 6).reversed()
        {
            let newDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: -i, to: currentDate, options: NSCalendar.Options(rawValue: 0))
            dateArray.add(newDate!)
        }
        
        let dateFormatter = CreateDateFormat()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        for i in 0 ... dateArray.count - 1
        {
            let convertedDate = dateFormatter.string(from: dateArray[i] as! Date)
            var dateStrArray = convertedDate.components(separatedBy: " ")
            if dateStrArray.count == 3
            {
                dateStrArray[1].remove(at: dateStrArray[1].index(before: dateStrArray[1].endIndex))
                if i == 0 || i == dateArray.count - 1
                {
                    strArray.add(dateStrArray[0])
                }
                strArray.add(dateStrArray[1])
            }
        }
        return strArray
    }
}

