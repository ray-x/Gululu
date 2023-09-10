//
//  LoginHelper.swift
//  Gululu
//
//  Created by Baker on 17/7/26.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class LoginHelper: NSObject {

    static let share = LoginHelper()
    
    let verifyCode_time : Int = 90
    var timer: DispatchSourceTimer?
    var sendPhoneNumber : String = ""
    var oneStepTime : DispatchTimeInterval = .seconds(1)
    var currendSetpTime : Int = 90
    var login_alter_tag = 0
    var loginPassword: String = ""
    var loginAccount: String = ""

    func AccountAviable(_ account:String?, _ cloudCallback:@escaping (Int)->Void){
        guard account != nil else {
            cloudCallback(0)
            return
        }
        GUser.share.email = account
        let requset = GUHttpRequest()
        if LoginHelper.share.checkUserInputIsEmail(account){
            requset.body["email"] = account
        }else{
            requset.body["phone"] = account
        }
        requset.setRequestConfig(.post, url: checkUserAccountUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let resultInt = self.handleCheckUserAccountDic(dic)
                cloudCallback(resultInt)
            }else{
                cloudCallback(0)
            }
        })
    }
    
    func handleCheckUserAccountDic(_ dic : NSDictionary) -> Int {
        guard dic.count != 0 else {
            return 0
        }
        let available : NSNumber? = dic["available"] as? NSNumber
        if available?.intValue == 0{
            return 1
        }else{
            return 2
        }
    }
    
    func phoneGetCode(_ phone:String?, type:String?, _ cloudCallback:@escaping (Int)  -> Void){
        guard phone != nil || phone != "" else {
            cloudCallback(0)
            return
        }
        guard type != nil || type != "" else {
            cloudCallback(0)
            return
        }
        
        let requset = GUHttpRequest()
        requset.body["phone"] = phone
        requset.body["type"] = type
        requset.body["action"] = "send"
        requset.setRequestConfig(.post, url: getPhoneCodeUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let resultInt = self.handlePhoneGetCodeResult(dic)
                cloudCallback(resultInt)
            }else{
                let err = result.error! as NSError
                cloudCallback(self.handlePhoneGetCodeResult(err.userInfo as NSDictionary))
            }
        })
    }
    
    func handlePhoneGetCodeResult(_ dic : NSDictionary) -> Int {
        guard dic.count != 0 else {
            return 0
        }
        let msg : String? = dic["msg"] as? String
        if msg == "send code success"{
            return 1
        }else{
            let error_code = dic["error_code"] as? String
            if error_code == "U-009"{
                return 2
            }else if error_code == "U-010"{
                return 3
            }else{
                return 4
            }
        }
    }
    
    func checkPhoneCode(_ phone:String?, code:String?, type:String?, _ cloudCallback:@escaping (Int)  -> Void){
        guard phone != nil || phone != "" || type != "" else {
            cloudCallback(0)
            return
        }
        
        let requset = GUHttpRequest()
        requset.body["phone"] = phone
        requset.body["verification_key"] = code
        requset.body["type"] = type
        requset.body["action"] = "check"
        requset.setRequestConfig(.post, url: checkPhoneCodeUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let resultInt = self.handleCheckPhoneCodeResult(dic)
                cloudCallback(resultInt)
            }else{
                cloudCallback(0)
            }
        })
    }
    
    func handleCheckPhoneCodeResult(_ dic : NSDictionary) -> Int {
        guard dic.count != 0 else {
            return 0
        }
        
        let msg : String? = dic["msg"] as? String
        if msg == "verify ok"{
            return 1
        }else{
            return 2
        }
    }
    
    func checkUserInputIsEmail(_ email: String?) -> Bool{
        guard email != nil else {
            return true
        }
        if (email?.contains("@"))!{
            return true
        }else{
            return false
        }
    }
    
    func singUpWithPhone(_ password : String, cloudCallback:@escaping (Bool)->Void) {
        let requset = GUHttpRequest()
        requset.body["phone"] = GUser.share.email
        requset.body["password"] = password
        requset.body["name"] = AppData.share.getUUID_from_keyChain()
        requset.setRequestConfig(.post, url: "/m/user")
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let callbackInt : Int = self.handleSignUpAndLoginDic(result.value!, password: password)
                if(callbackInt == 0)
                {
                    cloudCallback(false)
                }else{
                    cloudCallback(true)
                }
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func handleSignUpAndLoginDic(_ dic:NSDictionary, password:String) -> Int {
        guard  dic.count != 0 else {
            return 0
        }
        let status : String? = dic["status"] as? String
        if status == "OK"{
            let loginUser:Login = createObject(Login.self)!
            loginUser.email = GUser.share.email
            loginUser.passwd = password
            loginUser.token = dic["x_user_token"] as? String
            loginUser.userid = dic["user_id"] as? NSNumber
            loginUser.userSn = dic["x_user_sn"] as? String
            GUser.share.userSn = dic["x_user_sn"] as? String
            GUser.share.password = password
            GLoginUtil.share.setConfigServiceWithLogin(loginUser)
            loginUser.convertDict2Model(dic, callback: {_ in })
            
            let loginUserSatus = dic["user_status"] as? String
            if(loginUserSatus == "UNACTIVATED")
            {
                return 2
            }else{
              return 1
            }
        }else{
            return 0
        }
    }
    
    func loginWithAccount(_ password:String, cloudCallback:@escaping (Int)->Void) {
        guard password.count != 0 else{
            cloudCallback(0)
            return
        }
        let requset = GUHttpRequest()
        if(Common.isValidEmail(GUser.share.email!)){
            requset.body["email"] = GUser.share.email
        }else if(Common.isValidMobile(GUser.share.email!))
        {
            requset.body["phone"] = GUser.share.email
        }else{
            requset.body["email"] = GUser.share.email
        }
        requset.body["password"] = password
        requset.setRequestConfig(.post, url: loginUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let back = self.handleSignUpAndLoginDic(result.value!, password: password)
                if(Common.isValidEmail(GUser.share.email!)){
                    cloudCallback(back)
                }else if(Common.isValidMobile(GUser.share.email!))
                {
                    if(back > 0){
                        cloudCallback(1)
                    }else{
                        cloudCallback(0)
                    }
                }else{
                    cloudCallback(0)
                }
            }else{
                cloudCallback(0)
            }
        })
    }
    
    func resetUserPhonePassword(_ password:String,cloudCallback:@escaping (Bool)->Void) {
        guard password.count != 0 else{
            print("password is nil")
            return
        }
        let requset = GUHttpRequest()
        requset.body["phone"] = GUser.share.email
        requset.body["verification_key"] = GUser.share.verification_key
        requset.body["new_password"] = password
        requset.body["new_password_confirm"] = password
        requset.setRequestConfig(.put, url: resetPasswordUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue {
                let dic : NSDictionary = result.value!
                let status : String? = dic["status"] as? String
                if status == "OK"{
                    cloudCallback(true)
                }else{
                    cloudCallback(false)
                }
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func sendActiveEmail(_ account: String, _ password:String,cloudCallback:@escaping (Bool)->Void) {
        guard password.count != 0 else{
            print("password is nil")
            cloudCallback(false)
            return
        }
        
        guard account.count != 0 else{
            print("password is nil")
            cloudCallback(false)
            return
        }
        
        let requset = GUHttpRequest()
        requset.body["email"] = GUser.share.email
        requset.setRequestConfig(.post, url: sendAvtiveEmail)
        requset.handleRequset(callback: { result in
            cloudCallback(result.boolValue)
        })
    }
    
    
}
