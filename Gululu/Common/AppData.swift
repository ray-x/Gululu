//
//  AppData.swift
//  Gululu
//
//  Created by Baker on 16/7/13.
//  Copyright © 2016年 w19787. All rights reserved.
//

import UIKit
import SAMKeychain

class AppData: NSObject {
    
    static let share = AppData()
    
    var App_version: String! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var OS_version: String! = UIDevice.current.systemVersion
    
    let save_udid_Service = "SSToolkitTestService"
    let save_udid_Account = "SSToolkitTestAccount"
    let testPassword = "SSToolkitTestPassword"
    let testLabel = "SSToolkitLabel"
    
    var boolIOS10: Bool {
        return cheskupIosVersionIs10(OS_version)
    }
    
    func getUUID_from_keyChain() -> String {
        let udid_keyChain = SAMKeychainQuery()
        udid_keyChain.service = save_udid_Service
        udid_keyChain.account = save_udid_Account
        do{
           try udid_keyChain.fetch()
        }
        catch{
//            BH_Log("fetch udid failed", logLevel: .warning)
            BH_WARNING_LOG("fetch udid failed")
        }
        if isValidString(udid_keyChain.password){
            return udid_keyChain.password!
        }else{
            udid_keyChain.password = UIDevice.current.identifierForVendor?.uuidString
            do{
                try udid_keyChain.save()
            }
            catch{
//                BH_Log("save udid failed", logLevel: .warning)
                BH_WARNING_LOG("save udid failed")
            }
            return (UIDevice.current.identifierForVendor?.uuidString)!
        }
    }
    
    func getAllLanguagesNameJustAppleFirstSlect() {
        let languageArrray = UserDefaults.standard.object(forKey: "AppleLanguages")
        print(languageArrray ?? "111")
    }
    
    func getAppleAllhaveLanguage() {
        let local = NSLocale.availableLocaleIdentifiers
        print(local)
    }
    
    var phoneLanguage: String {
        let languages: [String] = Locale.preferredLanguages
        return languages[0]
    }
    
    var phoneLanguageFirst: String {
        let languages: [String] = Locale.preferredLanguages
        let lageFirst : String = languages.first!
        let langeArray = lageFirst.split(separator: "-")
        if languages[0].contains("zh-Hans"){
            return "zh-Hans"
        }else if languages[0].contains("zh-Hant"){
            return "zh-Hant"
        }else if languages[0].contains("zh"){
            return "zh-Hans"
        }else{
           return String(langeArray[0])
        }
    }
    
    var model_type: String! {
        var machineString : String = ""

        if Common.isRunOnSimulator() {
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineString = dir
            }
        } else {
            var systemInfo = utsname()
            uname(&systemInfo)
            
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            machineString = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8 , value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        
        switch machineString {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        default:                                        return machineString
        }
    }
    
    func cheskupIosVersionIs10(_ version: String) -> Bool {
        switch version.compare("10.0.0", options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            return true
        case .orderedAscending:
            return false
        }
    }
    
    func getAppInstallFirstTime() -> String{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let fileInfo : NSDictionary = try FileManager.default.attributesOfItem(atPath: documentsPath) as NSDictionary
            let createDate : Date = fileInfo.object(forKey: "NSFileCreationDate") as! Date
            return BKDateTime.getLocalDateString(createDate)
        }catch{
            return ""
        }
    }

}
