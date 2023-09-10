//
//  GLoginUtil.swift
//  Gululu
//
//  Created by Baker on 17/8/7.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

class GLoginUtil: NSObject {
    
    static let share = GLoginUtil()
    
    func setConfigServiceWithLogin(_ login : Login?) {
        if login?.token == nil{
            print("token nil")
        }else{
            cloudObj().token = login!.token
            GHHttpHelper.share.token = login!.token!
        }
        if login!.userSn == nil{
            print("userid nil")
        }else{
            JPUSHService.setAlias(login?.userSn, completion: { result,result1,result2  in
                print(result)
            }, seq: 0)
            //Flurry.setUserID(login!.userSn)
        }
        
        if login!.email == nil{
            print("email nil")
        }else{
            GUser.share.email = login!.email!
            if LoginHelper.share.checkUserInputIsEmail(login!.email){
                HelpshiftCore.setName(nil, andEmail: login!.email!)
            }
        }
    }
}
