//
//  LoginHttpHelper.swift
//  Gululu
//
//  Created by Baker on 17/7/28.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

extension LoginVC {
    
    func checkAccountAvaible(_ account:String) {
        if !isConnectNet() {
            LoadingView().stopAnimation()
            showCheckUserAccountFaied_no_network()
            return
        }
        LoginHelper.share.AccountAviable(account, { result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result == 0{
                    self.showCheckUserAccountFaied_no_service()
                }else if result == 1{
                    self.gotoNextVC(.inputPassword)
                }else if result == 2{
                    if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                        self.gotoNextVC(.createAccount)
                    }else{
                        if GUserConfigUtil.share.checkout_check_phone_code(){
                            self.gotoNextVC(.phoneGetCode)
                        }else{
                            self.gotoNextVC(.createAccount)
                        }
                    }
                }
            }
        })
    }
    
    func checkUserEmailAviable(_ email:String){
        if !isConnectNet() {
            LoadingView().stopAnimation()
            showCheckUserAccountFaied_no_network()
            return
        }
        GUser.share.checkUserEmailAviable(email, { result in
            DispatchQueue.main.async {
                if result == 0{
                    self.showCheckUserAccountFaied_no_service()
                }else if result == 1{
                    self.gotoNextVC(.inputPassword)
                }else if result == 2{
                    self.gotoNextVC(.createAccount)
                }
            }
        })
    }
    
    func setTheTimer() {
        LoginHelper.share.timer = DispatchSource.makeTimerSource(queue: .main)
        LoginHelper.share.timer?.schedule(deadline: .now(), repeating: LoginHelper.share.oneStepTime)
        LoginHelper.share.timer?.setEventHandler {
            let sencondStr = String(format:Localizaed("%d later get again"),LoginHelper.share.currendSetpTime)
            self.changeLoginButton.setTitle(sencondStr, for: .normal)
            LoginHelper.share.currendSetpTime = LoginHelper.share.currendSetpTime - 1
            self.changeLoginButton.isEnabled = false
            self.changeLoginButton.alpha = 0.8
            self.changeLoginButton.setleftImageJustNew(5.0)
            if LoginHelper.share.currendSetpTime <= 0{
                LoginHelper.share.currendSetpTime = LoginHelper.share.verifyCode_time
                self.deinitTimer()
            }
        }
        // 启动定时器
        LoginHelper.share.timer?.resume()
    }
    
    func deinitTimer() {
        if let time = LoginHelper.share.timer {
            let sencondStr = String(format:Localizaed("later get again"),LoginHelper.share.currendSetpTime)
            changeLoginButton.setImage(UIImage(named: "login_refresh_white"), for: .normal)
            changeLoginButton.isEnabled = true
            changeLoginButton.alpha = 1.0
            changeLoginButton.setTitle(sencondStr, for: .normal)
            changeLoginButton.setleftImageJustNew(5.0)
            time.cancel()
        }
    }
    
    func isNeedSendPhoneKey(phone:String) -> Bool {
        guard phone.count != 0 else {
            return false
        }
        if phone != LoginHelper.share.sendPhoneNumber{
            LoginHelper.share.sendPhoneNumber = phone
            LoginHelper.share.currendSetpTime = LoginHelper.share.verifyCode_time
            return true
        }else{
            if LoginHelper.share.currendSetpTime >= LoginHelper.share.verifyCode_time{
                return true
            }else{
                return false
            }
        }
    }
    
    
    func getPhoneCode(_ phone:String) {
        setTheTimer()
        if isNeedSendPhoneKey(phone: phone){
            LoadingView().showLodingInView()
            if !checkInternetConnection() {
                LoadingView().stopAnimation()
                return
            }
            LoginHelper.share.phoneGetCode(phone, type:"register",{ result in
                DispatchQueue.main.async {
                    LoadingView().stopAnimation()
                    if result == 1{
                        return
                    }else if result == 2{
                        self.showPhoneIsNotIlleaglAlter()
                    }else if result == 4{
                        self.showLimitServer()
                    }else{
                        self.showServerError()
                    }
                }
            })
        }
        
    }
    
    func showPhoneIsNotIlleaglAlter() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("phone is illeagl"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func showLimitServer() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("limit server"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func showServerError() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("server error"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func checkPhoneCode(_ phoneCode:String) {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        LoginHelper.share.checkPhoneCode(GUser.share.email, code: phoneCode, type:"register",{ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result == 1{
                    self.gotoNextVC(.createAccount)
                }else{
                    self.noticeLabel.text = Localizaed("      checkcode is wrong")
                    self.showAlterImage()
                }
            }
        })
    }
    
    //mark bhdelegate
    func cancleButtonDelegateAction() {
        //
    }
    
    func rightButtonDelegateAction() {
        //
        if LoginHelper.share.login_alter_tag == login_check_account_failed{
            Common.jumoToSystermAppNetWorkSetting()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                exit(0)
            }
        }
    }
    
    func showCheckUserAccountFaied_no_network() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: self.view.frame)
        LoginHelper.share.login_alter_tag = login_check_account_failed
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Please check your internet connection."), message:  Localizaed("Confirm the system settings agree that Gululu uses WLAN & Cellular Data"), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Go to setting"))
        alertView.presentBHAlertView()
    }
    
    func showCheckUserAccountFaied_no_service() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: self.view.frame)
        LoginHelper.share.login_alter_tag = login_check_account_failed
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Please check your internet connection."), message:  Localizaed("- 1.Make sure the network connection is normal\r\n- 2.The server may be disconnected，Please contact customer service."), leftBtnTitle: OK, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func loginSelf(_ inputext:String) -> Void {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        LoginHelper.share.loginWithAccount(inputTF.text!, cloudCallback: { result in
            GUser.share.password = self.inputTF.text!
            DispatchQueue.main.async {
                if result == 1{
                    self.getChildList()
                }else if result == 2{
                    self.signUpSuccess()
                }else{
                    self.loginFailed()
                }
            }
        })
    }
    
    func loginFailed() {
        LoadingView().stopAnimation()
        noticeLabel.text = Localizaed("      The password is incorrect.")
        if inputTF.isSecureTextEntry{
            vcModel = .passwordIncorrect
            setViewStyle()
            showPasswordVisible(showPasswordButton)
        }
    }
    
    func getChildList() -> Void {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        GChild.share.getChildList({ result in
            DispatchQueue.main.async {
                if result.boolValue{
                    if GChild.share.isHaveChild(){
                        self.logInSuccess()
                    }else{
                        self.gotoAddChildView()
                    }
                }else{
                    self.showGetChildListFailed()
                }
            }
        })
    }
    
    func showGetChildListFailed() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Please try again later"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    
    func singUp(_ inputext:String) -> Void {
        GUser.share.password = inputext
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
            GUser.share.singUp(inputext, cloudCallback: { result in
                DispatchQueue.main.async {
                    LoadingView().stopAnimation()
                    if result {
                        self.signUpSuccess()
                    }else{
                        self.showSingupFailed()
                    }
                }
            })
        }else{
            LoginHelper.share.singUpWithPhone(inputext, cloudCallback: { result in
                DispatchQueue.main.async {
                    LoadingView().stopAnimation()
                    if result {
                        self.gotoAddChildView()
                    }else{
                        self.showSingupFailed()
                    }
                }
            })
        }
    }
    
    func showSingupFailed() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Sing up failed,Please try again later."), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func resertPassword(inputext:String) {
        if GUser.share.password != inputTF.text{
            noticeLabel.text = Localizaed("      Password doesn't match.")
            LoadingView().stopAnimation()
            showAlterImage()
            return
        }
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
            GUser.share.resertPassword(inputTF.text!, cloudCallback: { result in
                DispatchQueue.main.async {
                    if result {
                        self.loginSelf(inputext)
                    }else{
                        self.showResetFailed()
                    }
                }
            })
        }else{
            LoginHelper.share.resetUserPhonePassword(inputext, cloudCallback: { result in
                DispatchQueue.main.async {
                    if result {
                        self.loginSelf(inputext)
                    }else{
                        self.showResetFailed()
                    }
                }
            })
        }
    }
    
    func showResetFailed(){
        LoadingView().stopAnimation()
        vcModel = .setNewPassword
        setViewStyle()
    }
    
    func show_no_phone_code_feature() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("We're sorry! This feature is currently down.  Please check again later or contact customer service."), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
}
