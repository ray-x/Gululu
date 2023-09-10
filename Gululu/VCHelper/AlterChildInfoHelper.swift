//
//  AlterChildInfoHelper.swift
//  Gululu
//
//  Created by Baker on 17/8/22.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class AlterChildInfoHelper: NSObject {
    
    static let share = AlterChildInfoHelper()

    var deleteChildName : String?
    
    var childInfoData : [InfoCell] = [InfoCell]()
    
    var alterViewTag = alter_no_bottle_view_tag
    
    func loadChildInfoDataFromUserInfo() {
        guard  activeChildID != "" else {
            return
        }
        var sexPhoto : UIImage?
        var sexStr : String?
        if GUser.share.activeChild?.gender == "girl" {
            sexPhoto = UIImage(named: "girl-3")
            sexStr = Localizaed("girl")
        }else{
            sexPhoto = UIImage(named: "boy_open")
            sexStr = Localizaed("boy")
        }
        let cellInfo1 = InfoCell(image: sexPhoto!, name: sexStr!)
        
        let birthdayImage = UIImage(named: "birthday copy")
        
        var birthdayStr = ""
        
        if GUser.share.activeChild?.birthday != nil {
            birthdayStr = Common.birthdayFormatEngBigWord((GUser.share.activeChild?.birthday)!)
        }
        let cellInfo2 = InfoCell(image: birthdayImage!, name: birthdayStr)
        
        let weightImage = UIImage(named:"weight copy")
        var weightStr = String()
        if GUser.share.activeChild?.unit != nil {
            if GUser.share.activeChild?.unit == "lbs" {
                if GUser.share.activeChild?.weightLbs != nil && GUser.share.activeChild?.unit != nil {
                    weightStr = String(format: "%@ %@",(GUser.share.activeChild?.weightLbs)!,(GUser.share.activeChild?.unit)!)
                }
            }else{
                if GUser.share.activeChild?.weight != nil && GUser.share.activeChild?.unit != nil {
                    weightStr = String(format: "%@ %@",(GUser.share.activeChild?.weight)!,(GUser.share.activeChild?.unit)!)
                }
            }
        }
        let cellInfo3 = InfoCell(image: weightImage!, name: weightStr)
        childInfoData = [cellInfo1,cellInfo2,cellInfo3]
    }
    
    
}
