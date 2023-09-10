//
//  AppDelegateHelper.swift
//  Gululu
//
//  Created by Baker on 17/4/5.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import Reachability

class AboutHelper: NSObject {
    
    static let share = AboutHelper()
    
    func getContantUsUrl() -> String {
        let languages = Common.checkPreferredLanguages()
        if languages == 2{
            return contant_us_zh_hant_url
        }else if languages == 1{
            return contant_us_zh_url
        }else{
            return contant_us_en_url
        }
    }
    
}
