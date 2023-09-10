//
//  Common.swift
//  Gululu
//
//  Created by Baker on 16/7/12.
//  Copyright © 2016年 w19787. All rights reserved.
//

import UIKit

class Common : NSObject{
    
    // MARK: Proving Email and Mobile format
    static func isValidEmail(_ mail:String)->Bool {
        let emailRegex = "[A-Z0-9a-z._+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: mail)
        
    }
    
    static func checkStrHaveEmoji(_ string : String) -> Bool {
        for char in string{
            let codePoint = String(char).unicodeScalars.first?.value
            if  (codePoint >= 0x2600 && codePoint <= 0x278a) // 杂项符号与符号字体
                || codePoint == 0x303D
                || codePoint == 0x2049
                || codePoint == 0x203C
                || (codePoint >= 0x2000 && codePoint <= 0x200F)//
                || (codePoint >= 0x2028 && codePoint <= 0x202F)//
                || codePoint == 0x205F //
                || (codePoint >= 0x2065 && codePoint <= 0x206F)//
                /* 标点符号占用区域 */
                || (codePoint >= 0x2100 && codePoint <= 0x214F)// 字母符号
                || (codePoint >= 0x2300 && codePoint <= 0x23FF)// 各种技术符号
                || (codePoint >= 0x2B00 && codePoint <= 0x2BFF)// 箭头A
                || (codePoint >= 0x2900 && codePoint <= 0x297F)// 箭头B
                || (codePoint >= 0x3200 && codePoint <= 0x32FF)// 中文符号
                || (codePoint >= 0xD800 && codePoint <= 0xDFFF)// 高低位替代符保留区域
                || (codePoint >= 0xE000 && codePoint <= 0xF8FF)// 私有保留区域
                || (codePoint >= 0xFE00 && codePoint <= 0xFE0F)// 变异选择器
                || codePoint >= 0x10000{
                return true
            }
        }
        return false
    }
    
    static func isValidMobile(_ mobile :String)->Bool {
        let mobileRegex="^1+\\d{10}$"
        if let _=mobile.range(of: mobileRegex, options: .regularExpression){
            return true
        }else{
            return false
        }
    }
    
    static func checkTextUniqueCharacter(_ char: String) -> Bool{
        let charRegex = "^[A-Z0-9a-z._-\\u4e00-\\u9fa5\\s]+$"
        return NSPredicate(format: "SELF MATCHES %@", charRegex).evaluate(with: char)
    }
    
    static func checkTextLengthAndChineseNums(_ text:String) -> (textLen: NSInteger, cnNum: NSInteger, hasUni: Bool){
        var textLen = 0
        var cnNum = 0
        var hasUni = false
        if text != "" {
            for i in 0...(text.count-1) {
                let iStr = (text as NSString).substring(with: NSRange(location: i, length: 1))
                if iStr.lengthOfBytes(using: String.Encoding.ascii) == 0{
                    cnNum += 1
                    textLen += 2
                } else {
                    textLen += 1
                }
                if self.checkTextUniqueCharacter(iStr) { hasUni = true }
            }
        } else {
            textLen = 0
        }
        return (textLen, cnNum, hasUni)
    }
    
    static func checkStringLength(_ str:String , strLength:Int) -> Bool {
        if str.count != strLength{
            return false
        }else{
            return true
        }
    }
    
    static func checkStringLengthBigThanSix(_ str:String , strLength:Int) -> Bool {
        if str.count < strLength{
            return false
        }else{
            return true
        }
    }
    
    static func isRunOnSimulator() -> Bool {
        #if arch(i386) || (arch(x86_64) && os(iOS))
            return true
        #endif
        return false
    }
    
    static func checkIfSSIDTextValid(_ ssid: String) -> Bool {
        if ssid.count > 0 {
            for i in 0...(ssid.count-1) {
                let iStr = (ssid as NSString).substring(with: NSRange(location: i, length: 1))
                if self.checkTextUniqueCharacterSSID(iStr) {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
    
    static func checkTextUniqueCharacterSSID(_ char: String) -> Bool {
        let index = char.unicodeScalars.first?.value
        if 32 <= index && index <= 126 {
            return false
        }
        return true
    }
    
    static func checkInternetConnection() -> Bool {
        let connStatus = NetworkStatusNotifier()
        
        switch connStatus.connectionStatus(){
        case .unknown, .offline:
            return false
        case .online(.wiFi), .online(.wwan):
            if PairCupHelper.share.isConnetGululuAP() {
                return false
            }
            return true
        }
    }
    
    static func birthdayFormatEngBigWord(_ bir:String?) -> String {
        var birDate = Date()
        if bir != nil{
            birDate = BKDateTime.getDateFromStr("yyyy-MM-dd HH:mm:ss", dateStr: bir!)
        }
        if Common.checkPreferredLanguagesIsEn() {
            return BKDateTime.getDateStrFormDate("MMM, yyyy", date: birDate)
        }else{
            return BKDateTime.getDateStrFormDate("yyyy年MMM", date: birDate)
        }
    }
    
    static func getSizeFromString(_ string:String, withFont font:UIFont?)->CGSize{
        let textSize = NSString(string: string ).size(
            withAttributes: [ NSAttributedStringKey.font:font!])
        return textSize
    }
    
    static func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedStringKey : AnyObject], context: nil).size
        return strSize.height
    }
    
    static func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedStringKey : AnyObject], context: nil).size
        return strSize.width
    }
    
    static func checkPreferredLanguages() -> Int {
        let languages = NSLocale.preferredLanguages
        let currentLanguage = languages.first
        if (currentLanguage?.contains("zh-Hans"))!{
            //zh-Hans-US
            return 1
        }else if (currentLanguage?.contains("zh-Hant"))!{
            return 2
        }else{
            //en-US 
            return 0
        }
    }
    
    static func checkPreferredLanguagesIsEn() -> Bool {
        let languages = NSLocale.preferredLanguages

        let currentLanguage = languages.first
        if (currentLanguage?.contains("zh"))!{
            //zh-Hans-US
            return false
        }else{
            //en-US
            return true
        }
    }
    
    static func checkPreferredLanguagesIsOnlyZh() -> Bool {
        let languages = NSLocale.preferredLanguages
        
        let currentLanguage = languages.first
        if (currentLanguage?.contains("zh-Hans"))!{
            //zh-Hans-US
            return true
        }else{
            //en-US
            return false
        }
    }
    
    static func checkStringIsCnOrEn(string:String?) -> Int {
        if string == nil || string == "" || string == " " || string?.count == 0{
            return 0
        }
        
        if string?.unicodeScalars.first?.value >= 0x4e00 && string?.unicodeScalars.first?.value <= 0x9fff{
            return 1
        }
        return 0
     }
    
    static func countStingCnAndEnCount(string:String?) -> Int {
        var count = 0
        var str : String = ""
        for char in string!{
            str.append(char)
            if checkStringIsCnOrEn(string: str) == 1{
                 count = count + 2
            }else{
                count = count + 1
            }
            str = ""
        }
        return count
    }
    
    static func jumpToSystermWifiSetting() {
        let urlObj = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(urlObj!, options: [:], completionHandler: nil)
    }
    
    static func jumoToSystermAppNetWorkSetting(){
        let urlObj = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(urlObj!, options: [:], completionHandler: nil)
    }
    
    static func cutImageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
        
}
