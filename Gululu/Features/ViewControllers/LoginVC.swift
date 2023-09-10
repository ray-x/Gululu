//
//  LoginVC.swift
//  Gululu
//
//  Created by Baker on 16/8/5.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

enum VcModel {
    case    inputEmail,
            inputPassword,
            createAccount,
            setNewPassword,
            setAgainNewPassword,
            passwordIncorrect,
            inputPhoneNumber,
            phoneGetCode,
            defaultModel
}

class LoginVC:  BaseViewController, UITextFieldDelegate, UITextViewDelegate, BHAlertViewDelegate{

    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var showPasswordButton : UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downInfoConstraint: NSLayoutConstraint!
    @IBOutlet weak var upConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputRightCon: NSLayoutConstraint!
    @IBOutlet weak var changeLoginButton: UIButton!
    @IBOutlet weak var inputLeftConstranit: NSLayoutConstraint!
    
    
    var upNoticeLabel: UILabel?
    var phoneLeftNumberLabel : UILabel?
    var phoneLeftWhiteLineLabel : UILabel?
    var changeLoginMethonBtn : UIButton?
    
    var vcModel  = VcModel.inputEmail
    var isUpNoticeLabelShow : Bool = false
    var upHeight : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoTextView()
        addUpLabel()
        setViewStyle()
        if vcModel == .phoneGetCode {
            getPhoneCode(GUser.share.email!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutViewModel()
        inputTF.becomeFirstResponder()
        notificationKeyboard()
        checkShowPhoneRegistButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUpNoticeLabelFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkShowPhoneRegistButton() {
        if vcModel == .inputPhoneNumber || vcModel == .inputEmail{
            if Common.checkPreferredLanguages() == 1{
                changeLoginMethonBtn?.isHidden = false
                createChangeMethodButton()
            }else{
                removeChangeMithonButton()
                changeLoginMethonBtn?.isHidden = true
            }
        }
        if vcModel == .phoneGetCode{
            if Common.checkPreferredLanguages() == 1{
                changeLoginButton.isHidden = false
            }else{
                changeLoginButton.isHidden = true
            }
        }else{
            changeLoginButton.isHidden = true
        }
    }
    
    func notificationKeyboard() {
        NotificationCenter.default.addObserver(self,selector:#selector(LoginVC.keyboardWillShow(_:)),name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.addObserver(self,selector:#selector(LoginVC.keyboardWillHide(_:)),name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
        //
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if upHeight == nil {
                    upHeight = downInfoConstraint.constant
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.downInfoConstraint.constant = keyboardSize.height + 10
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
        //
        UIView.animate(withDuration: 0.3, animations: {
            if self.upHeight != nil{
                self.downInfoConstraint.constant = self.upHeight!
            }
        })
    }
    
    //MARK: - ViewModel
    func setInfoTextView() -> Void {
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        inputTF.delegate = self
        infoTextView.delegate = self
        infoTextView.isEditable = false
        nextButton.titleLabel?.numberOfLines = 2
        nextButton.titleLabel?.textAlignment = NSTextAlignment.center
        inputTF.autocapitalizationType = .none
    }
    
    func addUpLabel() {
        if upNoticeLabel == nil {
            upNoticeLabel = UILabel(frame: inputTF.frame)
            upNoticeLabel!.textColor = .white
            upNoticeLabel!.font = UIFont(name: BASEFONT,size: 14)
            view.addSubview(upNoticeLabel!)
        }
    }
    
    func setupUpNoticeLabelFrame() {
        if upNoticeLabel != nil && isUpNoticeLabelShow == false{
            if upNoticeLabel!.frame.origin.y != inputTF.frame.origin.y {
                upNoticeLabel!.frame.origin.y = inputTF.frame.origin.y
                print(upNoticeLabel!.frame.origin.y)
            }
        }
    }
    
    func setViewStyle() -> Void {
        switch vcModel {
        case .inputEmail:
            showPasswordButton.isHidden = true
            inputTF.clearButtonMode = .whileEditing
            inputTF.isSecureTextEntry = false
            upNoticeLabel!.alpha = 0
            upNoticeLabel!.text = Localizaed("Parent's Email")
            inputLeftConstranit.constant = 35.0
            inputTF.keyboardType = .emailAddress
            inputTF.attributedPlaceholder =  NSAttributedString(string: Localizaed("someone@mygululu.com"), attributes:[NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)])
            nextButton.setTitle(NEXT, for: .normal)
            noticeLabel.text = Localizaed("Enter parent's email address to sign in or create an account.")
            hideCreatePhoneLeftNumber()
            GULabelUtil().setLogEmailInfoAttributedString(infoTextView)
            break
        case .inputPhoneNumber:
            showPasswordButton.isHidden = true
            inputTF.clearButtonMode = .whileEditing
            inputTF.isSecureTextEntry = false
            upNoticeLabel!.alpha = 0
            upNoticeLabel!.text = Localizaed("Phone")
            inputLeftConstranit.constant = 85.0
            inputTF.keyboardType = .phonePad
            inputTF.attributedPlaceholder =  NSAttributedString(string: Localizaed("Phone"), attributes:[NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)])
            nextButton.setTitle(NEXT, for: .normal)
            noticeLabel.text = Localizaed("please input you phone number to login or regist,(just allow china phone number now)")
            createPhoneLeftNumber()
            GULabelUtil().setLogEmailInfoAttributedString(infoTextView)
            break
        case .inputPassword:
            changeLoginButton.isHidden = true
            
            var originStr = ""
            var account = ""
            if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                originStr = Localizaed("You'll sign in with Parent's Email:")
                account = GUser.share.email!
            }else{
                originStr = Localizaed("You'll sign in with Phone:")
                account = String(format:"+86 %@",GUser.share.email!)
            }
            viewWithPasswordCommon(Localizaed("Password"), inputTFPlaceholer: Localizaed("Password"), nextButtonTitle: Localizaed("Sign\r in"), noticeLabelText: String(format: "%@ \r%@",originStr,account))
            GULabelUtil().setLabelWithUserNameLeftAttributedString(noticeLabel, originStr:originStr, userAccount:account)
            infoTextView.text = Localizaed("Forget password?")
            GULabelUtil().setAllLineAttributedString(infoTextView,UrlStr: "gotoVerifyCodeVC")
            break
        case .createAccount:
            var originStr = ""
            var account = ""
            var infoStr = ""
            if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                originStr = Localizaed("You'll create an account with Parent's Email:")
                account = GUser.share.email!
                infoStr = Localizaed("Wrong parent's email address?")
            }else{
                originStr = Localizaed("You'll create an account with Phone:")
                account = String(format:"+86 %@",GUser.share.email!)
                infoStr = Localizaed("Wrong phone address?")
            }
            viewWithPasswordCommon(Localizaed("Password"), inputTFPlaceholer: Localizaed("Password"), nextButtonTitle: Localizaed("Sign\r up"), noticeLabelText: String(format: "%@ \r%@",originStr,account))
            infoTextView.text = infoStr
            GULabelUtil().setAllLineAttributedString(infoTextView,UrlStr: "back")
            GULabelUtil().setLabelWithUserNameLeftAttributedString(noticeLabel,originStr: originStr, userAccount:account)
            break
        case .setNewPassword:
            infoTextView.isHidden = true
            nextButton.setBackgroundImage(UIImage(named: "buttonNormal"), for: .normal)
            nextButton.setBackgroundImage(UIImage(named: "buttonDisabled"), for: .disabled)
            nextButton.setBackgroundImage(UIImage(named: "buttonPressed"), for: .selected)
            viewWithPasswordCommon(Localizaed("Password"), inputTFPlaceholer: Localizaed("Your new password"), nextButtonTitle: NEXT, noticeLabelText: Localizaed("Please set your new password."))
            break
        case .setAgainNewPassword:
            infoTextView.isHidden = true
            nextButton.setBackgroundImage(UIImage(named: "Button6"), for: .normal)
            nextButton.setBackgroundImage(UIImage(named: "buttonDWMGray"), for: .disabled)
            nextButton.setBackgroundImage(UIImage(named: "button5"), for: .selected)
            viewWithPasswordCommon(Localizaed("Password"), inputTFPlaceholer: Localizaed("Your new password"), nextButtonTitle: Localizaed("Confirm"), noticeLabelText: Localizaed("Now, type it again to confirm."))
            break
        case .passwordIncorrect:
            viewWithPasswordCommon(Localizaed("Password"), inputTFPlaceholer: Localizaed("Password"), nextButtonTitle: Localizaed("Sign\r in"), noticeLabelText: Localizaed("      The password is incorrect."))
            infoTextView.text = Localizaed("Forget password?")
            GULabelUtil().setAllLineAttributedString(infoTextView,UrlStr: "gotoVerifyCodeVC")
            let alterImage = UIImageView(frame: CGRect(x: noticeLabel.frame.origin.x, y: noticeLabel.frame.origin.y+2, width: 17, height: 17))
            alterImage.image = UIImage(named: "login_forget_password")
            view.addSubview(alterImage)
            break
        case .phoneGetCode:
            var originStr = ""
            var account = ""
            if LoginHelper.share.checkUserInputIsEmail(GUser.share.email){
                originStr = Localizaed("You'll create an account with Parent's Email:")
                account = GUser.share.email!
            }else{
                originStr = Localizaed("You'll create an account with Phone:")
                account = String(format:"+86 %@",GUser.share.email!)
            }
            inputTF.keyboardType = .phonePad
            changeLoginButton.isEnabled = false
            changeLoginButton.isHidden = false
            changeLoginButton.setImage(UIImage(named: "login_refresh_white"), for: .normal)
            let sencondStr = String(format:Localizaed("%d later get again"),LoginHelper.share.currendSetpTime)
            changeLoginButton.setTitle(sencondStr, for: .normal)
            changeLoginButton.setleftImageJustNew(5.0)
            viewWithPasswordCommon(Localizaed("CheckCode"), inputTFPlaceholer: Localizaed("Please input you code"), nextButtonTitle: NEXT, noticeLabelText: String(format: "%@ \r%@",originStr,account))
            infoTextView.text = Localizaed("Wrong phone address?")
            GULabelUtil().setAllLineAttributedString(infoTextView,UrlStr: "back")
            GULabelUtil().setLabelWithUserNameLeftAttributedString(noticeLabel,originStr: originStr, userAccount:account)
            showPasswordButton.isHidden = true
            inputTF.isSecureTextEntry = false
            break
        default:
            break
        }
    }
    
    func createPhoneLeftNumber() {
        if phoneLeftNumberLabel == nil {
            phoneLeftNumberLabel = UILabel()
            phoneLeftNumberLabel?.text = "+86"
            phoneLeftNumberLabel?.textColor = .white
            phoneLeftNumberLabel?.font = UIFont(name: BASEFONT, size: 18)
            view.addSubview(phoneLeftNumberLabel!)
        } else {
            view.addSubview(phoneLeftNumberLabel!)
        }
        phoneLeftNumberLabel?.snp.makeConstraints({ (view) in
            view.top.equalTo(inputTF)
            view.bottom.equalTo(inputTF)
            view.left.equalTo(noticeLabel)
            view.right.equalTo(inputTF.snp.leftMargin).offset(-20)
        })
        
        if phoneLeftWhiteLineLabel == nil {
            phoneLeftWhiteLineLabel = UILabel()
            phoneLeftWhiteLineLabel?.backgroundColor = .white
            phoneLeftWhiteLineLabel?.text = ""
            view.addSubview(phoneLeftWhiteLineLabel!)
        } else {
            view.addSubview(phoneLeftWhiteLineLabel!)
        }
        
        phoneLeftWhiteLineLabel?.snp.makeConstraints({ (view) in
            view.top.equalTo(inputTF)
            view.bottom.equalTo(inputTF)
            view.right.equalTo(phoneLeftNumberLabel!).offset(5)
            view.width.equalTo(1.0)
        })
    }
    
    func hideCreatePhoneLeftNumber() {
        phoneLeftNumberLabel?.removeFromSuperview()
        phoneLeftWhiteLineLabel?.removeFromSuperview()
    }
    
    func showAlterImage() {
        let imageView = view.viewWithTag(loginAlterTag)
        if imageView == nil{
            let alterImage = UIImageView(frame: CGRect(x:noticeLabel.frame.origin.x, y:noticeLabel.frame.origin.y+2, width:17, height:17))
            alterImage.tag = loginAlterTag
            alterImage.image = UIImage(named: "login_forget_password")
            view.addSubview(alterImage)
        }else{
            imageView?.isHidden = false
        }
       
    }
    
    func hidenAlterImage() {
        let imageView = view.viewWithTag(loginAlterTag)
        imageView?.isHidden = true
    }
    
    func layoutViewModel() {
        switch vcModel {
        case .inputEmail,.inputPhoneNumber:
            navigationController?.setNavigationBarHidden(true, animated: true)
            backButton.isHidden = true
            inputRightCon.constant = 12
            upConstraint.constant = FIT_SCREEN_HEIGHT(84)
            checkUserEmailIsVailed()
            break
        case .inputPassword, .createAccount, .phoneGetCode, .setAgainNewPassword:
            backButton.isHidden = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            inputRightCon.constant = 42
            upConstraint.constant = FIT_SCREEN_HEIGHT(40)
            break
        case .setNewPassword:
            backButton.isHidden = false
            navigationController?.setNavigationBarHidden(true, animated: true)
            inputRightCon.constant = 42
            upConstraint.constant = FIT_SCREEN_HEIGHT(84)
            break
        case .passwordIncorrect :
            backButton.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            inputRightCon.constant = 42
            upConstraint.constant = FIT_SCREEN_HEIGHT(84)
            break
        default:
            break
        }
    }
    
    func viewWithPasswordCommon(_ upNoticeLabelText:String,inputTFPlaceholer:String,nextButtonTitle:String,noticeLabelText:String){
        showPasswordButton.isHidden = false
        inputTF.clearButtonMode = .never
        inputTF.isSecureTextEntry = true
        upNoticeLabel!.alpha = 0
        upNoticeLabel!.text = upNoticeLabelText
        inputTF.attributedPlaceholder =  NSAttributedString(string: inputTFPlaceholer, attributes:[NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)])
        nextButton.setTitle(nextButtonTitle, for: .normal)
        noticeLabel.text = noticeLabelText
    }
    
    //MARK: - UITextFieldDelegate
    @IBAction func inputChanged(_ sender: AnyObject) {
        if inputTF.text?.count != 0    {
            showUpEmailLabel(true)
        }else{
            showUpEmailLabel(false)
        }
        switch vcModel {
        case .inputEmail:
            checkUserEmailIsVailed()
        case .inputPhoneNumber:
            checkUserPhoneIsVailed()
        case .inputPassword, .passwordIncorrect:
            hidenAlterImage()
            checkPasswordVailed()
        case .phoneGetCode:
            checkPhoneCodeInvalied()
        case .createAccount, .setNewPassword, .setAgainNewPassword:
            checkResignPasswordVailed()
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch vcModel {
        case .inputPhoneNumber:
            if textField.text?.count >= 11 {
                if string != "" {
                    return false
                }
            }
        case .phoneGetCode:
            if textField.text?.count >= 4{
                if string != "" {
                    return false
                }
            }
        default:
            return true
        }
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL.absoluteString)
        if URL.absoluteString == "file:///gotoVerifyCodeVC" {
            if GUserConfigUtil.share.checkout_check_phone_code(){
                gotoVerifyCodeVC()
            }else{
                show_no_phone_code_feature()
            }
        }else if URL.absoluteString == "file:///back"{
            _ = navigationController?.popToRootViewController(animated: true)
        }else if URL.absoluteString == "file:///showPrivacy"{
            let broswerView = BrowserViewController()
            broswerView.webURL = privacy_web_url
            present(broswerView, animated: true, completion: nil)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nextButton.isEnabled {
            next(textField)
            return true
        }else{
            return false
        }
    }
    
    //MARK: - check
    func checkUserEmailIsVailed(){
        if Common.isValidEmail(inputTF.text!) {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func checkUserPhoneIsVailed() {
        if Common.isValidMobile(inputTF.text!) {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func checkPasswordVailed(){
        if inputTF.text?.count == 0 {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }else{
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }
    }
    
    func checkResignPasswordVailed(){
        if Common.checkStringLengthBigThanSix(inputTF.text!, strLength: 6){
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func checkPhoneCodeInvalied(){
        if Common.checkStringLength(inputTF.text!, strLength: 4){
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func showUpEmailLabel(_ needUp:Bool){
        if needUp{
            if !isUpNoticeLabelShow {
                UIView.animate(withDuration: 0.3, animations: {
                    self.isUpNoticeLabelShow = true
                    self.upNoticeLabel!.alpha = 0.5
                    self.upNoticeLabel!.frame.origin.y -= 28
                }) 
            }
        }else{
            if isUpNoticeLabelShow {
                UIView.animate(withDuration: 0.3, animations: {
                    self.isUpNoticeLabelShow = false
                    self.upNoticeLabel!.alpha = 0
                    self.upNoticeLabel!.frame.origin.y += 28
                }) 
            }
        }
    }
    
    func createChangeMethodButton() {
        if changeLoginMethonBtn == nil{
            changeLoginMethonBtn = UIButton()
            changeLoginMethonBtn?.addTarget(self, action: #selector(touchChangeMethonButton), for: .touchUpInside)
            changeLoginMethonBtn?.backgroundColor = .white
            changeLoginMethonBtn?.alpha = 0.8
            changeLoginMethonBtn?.layer.masksToBounds = true
            changeLoginMethonBtn?.layer.cornerRadius = 15
            changeLoginMethonBtn?.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 14)
            changeLoginMethonBtn?.setTitleColor(view.backgroundColor, for: .normal)
            view.addSubview(changeLoginMethonBtn!)
        }else{
            view.addSubview(changeLoginMethonBtn!)
        }
        changeLoginMethonBtn?.snp.makeConstraints({ (viewButton) in
            viewButton.top.equalTo(view).offset(37)
            viewButton.left.equalTo(view).offset(-15)
            viewButton.width.equalTo(145)
            viewButton.height.equalTo(30)
        })
        setChangeMethonButtontitle()
    }
    
    func setChangeMethonButtontitle() {
        if vcModel == .inputPhoneNumber{
            changeLoginMethonBtn?.setImage(UIImage(named: "login_change_mail"), for: .normal)
            changeLoginMethonBtn?.setTitle(Localizaed("parent's email login/register"), for: .normal)
        }else if vcModel == .inputEmail{
            changeLoginMethonBtn?.setImage(UIImage(named: "login_change_phone"), for: .normal)
            changeLoginMethonBtn?.setTitle(Localizaed("phone login/register"), for: .normal)
        }
        changeLoginMethonBtn?.setleftImageJustNew2(3.0)
    }
    
    func removeChangeMithonButton() {
        if changeLoginMethonBtn != nil {
            changeLoginMethonBtn?.removeFromSuperview()
        }
    }
    
    @objc func touchChangeMethonButton() {
        inputTF.resignFirstResponder()
        showUpEmailLabel(false)
        if vcModel == .inputEmail {
            vcModel = .inputPhoneNumber
            inputTF.text = ""
            setViewStyle()
        } else if vcModel == .inputPhoneNumber {
            vcModel = .inputEmail
            inputTF.text = ""
            setViewStyle()
        }
        inputTF.becomeFirstResponder()
        setChangeMethonButtontitle()
    }
    
    @IBAction func changeLogin(_ sender: Any) {
        if vcModel == .phoneGetCode {
            getPhoneCode(GUser.share.email!)
        }
    }
    
    //MARK: - Action Area
    @IBAction func showPasswordVisible(_ sender: AnyObject) {
        if showPasswordButton.isSelected {
            inputTF.isSecureTextEntry = true
        }else{
            inputTF.isEnabled = false
            inputTF.isSecureTextEntry = false
            inputTF.isEnabled = true
        }
        showPasswordButton.isSelected  = !showPasswordButton.isSelected
    }

    @IBAction func next(_ sender: AnyObject) {
        LoadingView().showLodingInView()
        nextButton.antiMultiplyTouch(1.0, closure: {})
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        let str = inputTF.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        inputTF.resignFirstResponder()
        switch vcModel {
        case .inputEmail:
            checkUserEmailAviable(str!)
        case .inputPhoneNumber:
            checkAccountAvaible(str!)
        case .inputPassword, .passwordIncorrect:
            loginSelf(str!)
        case .setNewPassword:
            GUser.share.password = str
            gotoNextVC(.setAgainNewPassword)
        case .createAccount:
            singUp(str!)
        case .setAgainNewPassword:
            resertPassword(inputext: str!)
        case .phoneGetCode:
            checkPhoneCode(str!)
        default:
            return
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        for viewC : UIViewController in (navigationController?.viewControllers)! {
            if viewC.isKind(of: LoginVC.self) {
                let navLoginVC : LoginVC = viewC as! LoginVC
                if navLoginVC.vcModel == .inputPassword {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                    transition.type = kCATransitionReveal
                    transition.subtype  = kCATransitionFromBottom
                    navigationController?.view.layer.add(transition, forKey: nil)
                    _ = navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }

    //MARK: - changeVC
    func gotoVerifyCodeVC() -> Void {
        LoadingView().stopAnimation()
        let mainSB = UIStoryboard(name: "Login", bundle: nil)
        let verifyCodeVC: VerifyCodeVC = mainSB.instantiateViewController(withIdentifier: "verifyVC") as! VerifyCodeVC
        verifyCodeVC.codeModel = .firstVerifyModel
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(verifyCodeVC, animated: false)
    }
    
    func gotoAddChildView() {
        LoadingView().stopAnimation()
        GUser.share.appStatus = .registered
        goto(vcName: "childSetup", boardName: "Register")
    }
    
    func gotoNextVC(_ vcModel:VcModel) -> Void {
        LoadingView().stopAnimation()
        let mainSB = UIStoryboard(name: "Login", bundle: nil)
        let mainVC: LoginVC = mainSB.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
        mainVC.vcModel = vcModel
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func logInSuccess() {
        LoadingView().stopAnimation()
        goto(vcName: "showMainVC", boardName: "Main")
    }
    
    func signUpSuccess(){
        LoadingView().stopAnimation()
        let mainSB = UIStoryboard(name: "Login", bundle: nil)
        let vc: ActiveEmailVC = mainSB.instantiateViewController(withIdentifier: "ActiveEmailID") as! ActiveEmailVC
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
}
