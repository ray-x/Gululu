//
//  parentAccountVC.swift
//  Gululu
//
//  Created by Ray Xu on 6/02/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

enum stateUserInfo{
    case showLogout
    case emailInput
    case passwdinput
    case passwdVerify
}

class ParentAccountVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var parentTitle: UILabel!
    @IBOutlet weak var parentMail: UITextField!
    @IBOutlet weak var nextButDist: NSLayoutConstraint!
    @IBOutlet weak var Log_NextButton: UIButton!
    
    var emailChanged:Bool=false
    var email:String?
    var passwd:String?
    var passwdVerifed:String?
    var inputState:stateUserInfo! = .showLogout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentMail.isEnabled = false
        parentTitle.text = Localizaed("Parent's account")
        if GUser.share.email != nil{
            parentMail.text = GUser.share.email
        }else {
            parentMail.text = Localizaed("New eMail")
        }
        
        if LoginHelper.share.checkUserInputIsEmail(GUser.share.email) == false{
            parentMail.text = "+86 " + GUser.share.email!
        }
        parentMail.addTarget(self, action: #selector(parentEmailChanged), for: .editingChanged)
        Log_NextButton.setTitle(Localizaed("Log\rout"), for: .normal)
        Log_NextButton.titleLabel?.numberOfLines = 0
        let login : Login? = createObject(Login.self ,objectID: "Login")
        guard login?.email != nil else {
            return
        }
        email = login!.email
        passwd = login!.passwd
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout_Next(_ sender: AnyObject) {
        if inputState == .showLogout {
            GUser.share.userLogOut()
            for VC : UIViewController in (navigationController?.viewControllers)! {
                if VC.isKind(of: MainVC.self) {
                    let Vcsss : MainVC = (VC as? MainVC)!
                    Vcsss.clearMermory()
                }
            }
            let startVC:LoginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            navigationController?.viewControllers[0]=startVC
            if Common.checkPreferredLanguages() == 1{
                startVC.vcModel = .inputPhoneNumber
            }else{
                startVC.vcModel = .inputEmail
            }
            _ = navigationController?.popToRootViewController(animated: true)
        }else{
            handleNext()
        }
    }
    
    func handleNext(){
        switch inputState! {
        case .showLogout:
            print("state error")
        case .emailInput:
            changeToPasswd()
            print("state emailInput")
        case .passwdinput:
            changeToPasswdVerify()
            print("state passwdinput")
        case .passwdVerify:
            changeToPasswdConfirm()
            print("state passwdVerify")
        }
    }
    
    func changeToPasswd()
    {
        if email! != parentMail.text!
        {
            Log_NextButton.setBackgroundImage(UIImage(named: "Button6"), for: .normal)
            Log_NextButton.setTitle("Confirm", for: .normal)
            email = parentMail.text!
            parentMail.text = "Enter your password to confirm"
            let str = NSAttributedString(string: "Enter your password to confirm", attributes: [NSAttributedStringKey.foregroundColor:UIColor(red: 1, green: 1, blue: 1, alpha: 0.6) ])
            parentMail.text=""
            parentMail.attributedPlaceholder = str
            parentMail.isSecureTextEntry=true
            inputState = .passwdinput
        }
    }
    
    func changeToPasswdVerify()
    {
        if parentMail.text!.count != 0 && parentMail.text == passwd
        {
            let str = NSAttributedString(string: "Enter your new password", attributes: [NSAttributedStringKey.foregroundColor:UIColor(red: 1, green: 1, blue: 1, alpha: 0.6) ])
            parentMail.text=""
            parentMail.attributedPlaceholder = str
            parentMail.isSecureTextEntry=true
            inputState = .passwdVerify
        }else{
            shakeTextInput()
        }
    }
    
    func changeToPasswdConfirm()
    {
        if Common.checkStringLengthBigThanSix(parentMail.text!,strLength: 6)
        {
            print("success")
            GUser.share.email = email!
//            GUser.share.password = self.passwd!
            self.navigationController!.popViewController(animated: true)
        }else{
            let alertView = BHAlertView(frame: view.frame)
            alertView.initAlertContent("", message: Localizaed("Password at least six length"), leftBtnTitle: DONE, rightBtnTitle: "")
            alertView.presentBHAlertView()
        }
    }
    
    func shakeTextInput()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: parentMail.center.x - 10, y: parentMail.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: parentMail.center.x + 10, y: parentMail.center.y))
        parentMail.layer.add(animation, forKey: "position")
    }
    
    @objc func parentEmailChanged(){
        if Log_NextButton.titleLabel?.text == "Next"{
            if parentMail.text == email{
                Log_NextButton.isEnabled = false
            }else{
                Log_NextButton.isEnabled = true
            }
        }
    }
    
    //MARK: -
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //nextButDist.constant -= CGFloat(self.SCREEN_HEIGHT/3)
        Log_NextButton.setTitle("Next", for: .normal)
        self.Log_NextButton.isEnabled = false
        inputState = .emailInput
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //nextButDist.constant += CGFloat(self.SCREEN_HEIGHT/3)
        if  parentMail.text == email  {
             Log_NextButton.setTitle("Log\rout", for: .normal)
            Log_NextButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parentMail.resignFirstResponder()
        Logout_Next(Log_NextButton)
        return true
    }
}

