//
//  VerifyCodeVC.swift
//  Gululu
//
//  Created by Baker on 16/8/7.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

enum CodeModel {
    case firstVerifyModel,secondVerifyModel,fiveVerifyModel,defaultModel
}

class VerifyCodeVC: BaseViewController ,UITextViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var noticeTextView: UITextView!
    
    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var codeView: UIView!
    
    var enterVerifyCodeTime : Int = 0
    
    var codeModel : CodeModel = .firstVerifyModel
    
    var upHeight : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewContent()
        setFourCodeTestFeild()
        setViewModel()
        getVerifyCode()
        notificationKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.resertTextView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func notificationKeyboard() {
        NotificationCenter.default.addObserver(self,selector:#selector(VerifyCodeVC.keyboardWillShow(_:)),name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.addObserver(self,selector:#selector(VerifyCodeVC.keyboardWillHide(_:)),name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
        //
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if upHeight == nil {
                    upHeight = downConstraint.constant
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.downConstraint.constant = keyboardSize.height + 10
                })
                // ...
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
        
    }
    
    @objc func keyboardWillHide(_ sender:Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.upHeight != nil{
                self.downConstraint.constant = self.upHeight!
            }
            print(self.noticeTextView.frame)
        })
    }
    
    func setTextViewContent() -> Void {
        navigationController?.isNavigationBarHidden = true
        noticeTextView.delegate = self
        noticeTextView.isEditable = false
        codeView.backgroundColor = .clear
        noticeTextView.font = UIFont(name: BASEFONT, size: 14)
        noticeTextView.isScrollEnabled = false
        noticeTextView.backgroundColor = .clear
        noticeTextView.textAlignment = .center
    }
    
    func setFourCodeTestFeild() -> Void {
        for i  in  0...3{
            let x1 : Float = Float(FIT_SCREEN_WIDTH(23.5))
            let x2 : Float = (Float(i)*Float(FIT_SCREEN_WIDTH(70)))
            let x : CGFloat = CGFloat(x1 + x2)
            let textField : UITextField = UITextField(frame: CGRect(x: x, y: 0, width: FIT_SCREEN_WIDTH(48), height: FIT_SCREEN_WIDTH(58)))
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.borderWidth = 4
            textField.layer.cornerRadius = 10
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.tintColor = .clear
            textField.textAlignment = .center
            textField.textColor = .white
            textField.font = UIFont(name: BASEBOLDFONT,size: 28)
            textField.tag = i + verifyCodeViewTag
            codeView.addSubview(textField)
        }
    }
    
    func resertTextView() -> Void {
        for i in 0...3 {
            let textField : UITextField = codeView.viewWithTag(i+verifyCodeViewTag) as! UITextField
            textField.text = ""
            if i == 0{
                textField.isUserInteractionEnabled = true
                textField.becomeFirstResponder()
            }else{
                textField.isUserInteractionEnabled = false
            }
        }
    }
    
    func setViewModel() -> Void {
        switch codeModel {
        case .firstVerifyModel:
            var originStr = ""
            var userAccountStr = ""
            let  lastStr = Localizaed("Please enter the code you received to continue resetting your password.")
            if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                originStr = Localizaed("We've sent the security code to:")
                userAccountStr = GUser.share.email!
                noticeTextView.text = Localizaed("Wait. that is a wrong parent's email address")
            }else{
                originStr = Localizaed("We've sent the security code to phone:")
                userAccountStr = String(format:"+86 %@",GUser.share.email!)
                noticeTextView.text = Localizaed("Wrong phone address?")
            }
            mainLabel.text = String(format: "%@\r%@\r%@",originStr,userAccountStr,lastStr)

            GULabelUtil().setLabelWithUserNameCenterAttributedString(mainLabel,originStr: originStr)

            noticeTextView.alpha = 0.8
            GULabelUtil().setAllLineAttributedString(noticeTextView, UrlStr: "back")           
        case .secondVerifyModel:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.resertTextView()
            }
            
            noticeTextView.text = Localizaed("It is incorrect.")
            noticeTextView.alpha = 1.0
            showAlterImage()
            GULabelUtil().setViewNormolStyle(noticeTextView)
        case .fiveVerifyModel:
            resertTextView()
            var originStr = ""
            var userAccountStr = ""

            if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                originStr = Localizaed("You've tried too many times.\r We've sent a new verification code to:")
                userAccountStr = GUser.share.email!
                mainLabel.text = String(format: Localizaed("%@\r%@\r Please check it and try agian."),originStr,userAccountStr)
            }else{
                userAccountStr = String(format:"+86 %@",GUser.share.email!)
                originStr = Localizaed("You've tried too many times.\r We've sent a new verification code to phone:")
                mainLabel.text = String(format: Localizaed("%@\r%@\r Please check it and try agian."),originStr,userAccountStr)
            }
            
            GULabelUtil().setLabelWithUserNameCenterAttributedString(mainLabel,originStr: originStr)
            noticeTextView.text = Localizaed("It is incorrect.")
            showAlterImage()
            noticeTextView.alpha = 1.0
            GULabelUtil().setViewNormolStyle(noticeTextView)
        default:
            break
        }
    }
    
    func showAlterImage() {
        let imageView = view.viewWithTag(verify_code_alter_tag)
        if imageView == nil{
            let noticeTest = noticeTextView.text
            let fout  = UIFont(name: BASEFONT, size: 18)
            let size = Common.getSizeFromString(noticeTest!, withFont:fout)
            let alterImage = UIImageView(frame: CGRect(x: (SCREEN_WIDTH-size.width)/2-20, y: noticeTextView.frame.origin.y+5, width: 17, height: 17))
            alterImage.tag = verify_code_alter_tag
            alterImage.image = UIImage(named: "login_forget_password")
            view.addSubview(alterImage)

        }else{
            imageView?.isHidden = false
        }
    }
    
    func hidenAlterImage() {
        let imageView = view.viewWithTag(verify_code_alter_tag)
        imageView?.isHidden = true
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
            noticeTextView.text = Localizaed("Wait. that is a wrong parent's email address")
        }else{
            noticeTextView.text = Localizaed("Wrong phone address?")
        }
        noticeTextView.alpha = 0.8
        GULabelUtil().setAllLineAttributedString(noticeTextView, UrlStr: "back")
    }

    @IBAction func dissMissVC(_ sender: AnyObject) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    func checkTextFeildWillBecomeFirst(_ textField: UITextField,string:String) -> Void {
        if textField.tag != verifyCodeViewTag+3{
            textField.isUserInteractionEnabled = false
            let nextTextField : UITextField = codeView.viewWithTag(textField.tag+1) as! UITextField
            nextTextField.isUserInteractionEnabled = true
            nextTextField.text  = string
            nextTextField.becomeFirstResponder()
            if nextTextField.tag == verifyCodeViewTag+3 {
                checkVerifyCode()
            }
        }
    }
    
    func checkTextFeildWillDelete(_ textField: UITextField) -> Void {
        if textField.tag != verifyCodeViewTag{
            textField.text = ""
            textField.isUserInteractionEnabled = false
            let nextTextField : UITextField? = codeView.viewWithTag(textField.tag-1) as? UITextField
            if nextTextField != nil{
                nextTextField?.isUserInteractionEnabled = true
                nextTextField?.becomeFirstResponder()
            }
        }else{
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == verifyCodeViewTag {
            hidenAlterImage()
        }
        if string == "" {
            checkTextFeildWillDelete(textField)
            return false
        }else if textField.text?.count == 1{
            hidenAlterImage()
            checkTextFeildWillBecomeFirst(textField,string: string)
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL.absoluteString)
        if URL.absoluteString == "file:///gotoVerifyCodeVC" {
           //
        }else if URL.absoluteString == "file:///back"{
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            transition.type = kCATransitionReveal
            transition.subtype  = kCATransitionFromBottom
            navigationController?.view.layer.add(transition, forKey: nil)
            _ = navigationController?.popToRootViewController(animated: false)
        }else{
            let broswerView = BrowserViewController()
            broswerView.webURL = URL.absoluteString
            present(broswerView, animated: true, completion: nil)
        }
        
        return true
    }
    
    func gotoNextVC(_ vcModel:VcModel) -> Void {
        let mainSB = UIStoryboard(name: "Login", bundle: nil)
        let mainVC: LoginVC = mainSB.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
        mainVC.vcModel = vcModel
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
}

extension VerifyCodeVC{
    
    func getUserInputCode() -> String {
        let code : NSMutableString = ""
        for i in 0...3 {
            let textField : UITextField = view.viewWithTag(i+verifyCodeViewTag) as! UITextField
           code.append(textField.text!)
        }
        return code as String
    }
    
    func checkVerifyCode(){
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        GUser.share.verification_key = getUserInputCode()
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
            GUser.share.checkVerifyCode({ result in
                DispatchQueue.main.async {
                    if result {
                        self.gotoNextVC(.setNewPassword)
                    }else{
                        self.checkCodeFailed()
                    }
                }
            })
        }else{
            checkUserPhoneCode(GUser.share.verification_key)
        }
        
    }
    
    func checkUserPhoneCode(_ code:String?)  {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        LoginHelper.share.checkPhoneCode(GUser.share.email, code: code, type: "forget", { result in
            DispatchQueue.main.async {
                if result == 1 {
                    self.gotoNextVC(.setNewPassword)
                }else{
                    self.checkCodeFailed()
                }
            }
        })
    }
    
    func checkCodeFailed(){
        print(enterVerifyCodeTime)
        if enterVerifyCodeTime == 0 && codeModel == .fiveVerifyModel{
            resertTextView()
            codeModel = .firstVerifyModel
            enterVerifyCodeTime = 1
            setViewModel()
        }else if enterVerifyCodeTime == 4 {
            codeModel = .fiveVerifyModel
            enterVerifyCodeTime = 0
            getVerifyCode()
        }else{
            codeModel = .secondVerifyModel
            enterVerifyCodeTime = enterVerifyCodeTime + 1
            setViewModel()
        }

    }
    
    func getVerifyCode() {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
            GUser.share.getVerifyCode({ result in
                DispatchQueue.main.async {
                    if result {
                        self.setViewModel()
                    }else{
                        self.getVerifykeyFailed()
                    }
                }
            })
        }else{
            getPhoneVerifyCode()
        }
        
    }

    func getPhoneVerifyCode() {
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        LoginHelper.share.phoneGetCode(GUser.share.email, type: "forget", { result in
            DispatchQueue.main.async {
                if result == 1{
                    self.setViewModel()
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
    
    func getVerifykeyFailed() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Get code failed, Please try again later."), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
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
}
