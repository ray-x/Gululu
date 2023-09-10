//
//  GUserRequest.swift
//  Gululu
//
//  Created by baker on 2017/11/23.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GUserRequest: NSObject {

}

extension GUser{
    func checkUserEmailAviable(_ email:String?, _ cloudCallback:@escaping (Int)->Void){
        guard email != nil else {
            cloudCallback(0)
            return
        }
        cloudObj().checkUserEmailAvailable(email!) { (result) in
            if result.boolValue {
                let dic : NSDictionary = result.value!
                let available : NSNumber? = dic["available"] as? NSNumber
                self.email = email
                if available?.intValue == 0{
                    cloudCallback(1)
                }else{
                    cloudCallback(2)
                }
            }else{
                cloudCallback(0)
            }
        }
    }
    
    func checkUserPassword(_ cloudCallback:@escaping (Bool) -> Void) {
        let login : Login? = getRealLogin()
        guard  login != nil else {
            cloudCallback(false)
            return
        }
        GUser.share.email = login?.email
        if LoginHelper.share.checkUserInputIsEmail(login?.email){
            check_user_password_by_email(login!, cloudCallback: { (result) in
                cloudCallback(result)
            })
        } else {
            check_user_password_by_phone(login!, cloudCallback: { (result) in
                cloudCallback(result)
            })
        }
    }
    
    func review_user_info(_ login: Login?, cloudCallback:@escaping (Login?) -> Void) {
        guard login != nil else {
            return
        }
        guard login?.passwd != nil && login?.email != nil else {
            return
        }
        CloudComm.shareObject.token = login?.token
        if LoginHelper.share.checkUserInputIsEmail(login?.email){
            login?.update(.fetch, uiCallback:{ result in
                if !result.boolValue{
                    let error_str = String(format:"phone=%@, password=%@", (login?.email)!, (login?.passwd)!)
                    BH_ERROR_LOG("update user info error_str =" + error_str)
                    cloudCallback(login)
                }else{
                    BH_INFO_LOG("reload email success.")
                    cloudCallback(login)
                }
            })
        } else {
            let requset = GUHttpRequest()
            GHHttpHelper.share.token = (login?.token)!
            requset.body["phone"] = login?.email
            requset.body["password"] = login?.passwd
            requset.setRequestConfig(.post, url: loginUrl)
            requset.handleRequset(callback: { result in
                if result.boolValue{
                    login!.token = result.value?["token"] as? String
                    login!.userSn = result.value?["x_user_sn"] as? String
                    login!.userid = result.value?["user_id"] as? NSNumber
                    saveContext()
                    BH_INFO_LOG("reload phone success.")
                    cloudCallback(login)
                }else{
                    let error_str = String(format:"phone=%@, password=%@", (login?.email)!, (login?.passwd)!)
                    BH_ERROR_LOG("update user info error_str =" + error_str)
                    cloudCallback(login)
                }
            })
        }
    }
    
    func check_user_password_by_email(_ login:Login, cloudCallback:@escaping (Bool) -> Void) {
        login.update(.fetch, uiCallback:{ result in
            if result.boolValue{
                guard self.activeChild != nil else{
                    return
                }
                GLoginUtil.share.setConfigServiceWithLogin(login)
                cloudCallback(true)
                GChild.share.getChildList({_ in})
            }else{
                let err = result.error! as NSError
                if err.userInfo["error_code"] as? String == "U-005"{
                    cloudCallback(false)
                }
            }
        })
    }
    
    func check_user_password_by_phone(_ login:Login, cloudCallback:@escaping (Bool) -> Void) {
        let requset = GUHttpRequest()
        requset.body["phone"] = GUser.share.email
        requset.body["password"] = login.passwd
        requset.setRequestConfig(.post, url: loginUrl)
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let phoneLogin : Login = self.getRealLogin()!
                phoneLogin.email = GUser.share.email
                phoneLogin.token = result.value?["token"] as? String
                phoneLogin.userSn = result.value?["x_user_sn"] as? String
                phoneLogin.userid = result.value?["user_id"] as? NSNumber
                saveContext()
                GLoginUtil.share.setConfigServiceWithLogin(phoneLogin)
                GChild.share.getChildList({_ in})
                cloudCallback(true)
            }else{
                let err = result.error! as NSError
                if err.userInfo["error_code"] as? String == "U-005"{
                    cloudCallback(false)
                }
            }
        })
    }
    
    func login(_ password : String, cloudCallback:@escaping (Bool)->Void) {
        let loginUser:Login = createObject(Login.self)!
        loginUser.email = email
        loginUser.passwd = password
        loginUser.update(.fetch, uiCallback:{ result in
            switch result{
            case .Success:
                self.userSn = loginUser.userSn
                self.email = loginUser.email
                GLoginUtil.share.setConfigServiceWithLogin(loginUser)
                cloudCallback(true)
            case .Error:
                cloudCallback(false)
            }
        })
    }
    
    func singUp(_ password : String, cloudCallback:@escaping (Bool)->Void) {
        let loginUser:Login = createObject(Login.self)!
        loginUser.email = email
        loginUser.passwd = password
        loginUser.update(uiCallback:  { result in
            switch result{
            case .Success:
                GLoginUtil.share.setConfigServiceWithLogin(loginUser)
                cloudCallback(true)
            case .Error :
                cloudCallback(false)
            }
        })
    }
    
    func resertPassword(_ agianPassword : String, cloudCallback:@escaping (Bool)->Void) {
        cloudObj().resetNewPassword(email!,password: password!,agianPassword:agianPassword,verification_key:verification_key) { (result) in
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
        }
    }
    
    func checkVerifyCode(_ cloudCallback:@escaping (Bool)->Void) {
        cloudObj().checkUserEmailVerifyCode(email!,verifyCode:verification_key) { (result) in
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
        }
    }
    
    func getVerifyCode(_ cloudCallback:@escaping (Bool)->Void) {
        cloudObj().sendUserEmailVerifyCode(email!) { (result) in
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
        }
    }
    
    func createChildren(_ cloudCallback:@escaping (Bool) -> Void){
        workingChild?.update(.create, uiCallback: { result in
            DispatchQueue.main.async {
                if result.boolValue{
                    if self.workingChildChosePhoto {
                        AvatorHelper.share.convertAddChildAvatorImageName("workingID", newID: ( GUser.share.workingChild?.childID)!)
                    }
                    self.isChildCreated = true
                    self.setGlobalChild(GUser.share.workingChild)
                    cloudCallback(true)
                }else{
                    self.isChildCreated = false
                    cloudCallback(false)
                }
            }
        })
    }
    
    func updateChilren(_ cloudCallback:@escaping (Bool) -> Void) {
        let child:Children? = createObject(Children.self, objectID: workingChild?.childID)
        if child != nil{
            child!.childName = workingChild?.childName
            child!.birthday = workingChild?.birthday
            child?.unit = workingChild?.unit
            if child?.unit == "lbs" {
                child?.weightLbs = workingChild?.weightLbs
                child?.weight = nil
            }else{
                child?.weightLbs = nil
                child?.weight = workingChild?.weight
            }
            child!.update(.update, uiCallback: { result in
                DispatchQueue.main.async {
                    cloudCallback(result.boolValue)
                }
            })
        }
    }
}
