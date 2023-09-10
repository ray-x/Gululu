//
//  ActiveEmailVC.swift
//  Gululu
//
//  Created by baker on 2018/6/15.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

class ActiveEmailVC: BaseViewController, UITextViewDelegate {

    
    @IBOutlet weak var ConTitleLabel: UILabel!
    @IBOutlet weak var SuccLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var activeTextView: GUTextView!
    @IBOutlet weak var AcButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipsLabel.isHidden = true
        
        activeTextView.delegate = self
        activeTextView.isEditable = false
        GULabelUtil.setVerifyEmailTips(activeTextView)
        
        let originStr = Localizaed("We have sent a welcome E-mail to")
        let userAccountStr = GUser.share.email
        let  lastStr = Localizaed("Please check your email to\rcomplete the account setup\rprocess.")
        
        titleLabel.text = String(format: "%@\r%@\r%@",originStr,userAccountStr!,lastStr)
        ConTitleLabel.text = Localizaed("Congratulations") + "!"
        SuccLabel.text = Localizaed("You've succesfully registered.")
        tipsLabel.text = Localizaed("Your account is not actived,\rPlease check your E-mail")
        AcButton.setTitle(Localizaed("Proceed"), for: .normal);
        GULabelUtil().setLabelWithUserNameCenterAttributedString(titleLabel,originStr: originStr)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActivedEmail(_ sender: Any) {
        LoadingView().showLodingInView()
        LoginHelper.share.loginWithAccount(GUser.share.password!) { (result) in
            DispatchQueue.main.async {
                if(result == 1)  {
                    self.gotoAddChildView()
                }else if result == 2{
                    self.showActiveFalied()
                }else{
                    AlterView.showConnectServerError()
                }
            }
        }
    }
    
    func gotoAddChildView() {
        LoadingView().stopAnimation()
        GUser.share.appStatus = .registered
        goto(vcName: "childSetup", boardName: "Register")
    }
    
    func showActiveFalied() {
        LoadingView().stopAnimation()
        tipsLabel.isHidden = false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "file:///sendValiedEmail"{
            guard GUser.share.email != nil else{
                AlterView.showConnectServerError()
                return true
            }
            
            guard GUser.share.password != nil else{
                AlterView.showConnectServerError()
                return true
            }
            LoginHelper.share.sendActiveEmail(GUser.share.email!, GUser.share.password!, cloudCallback: { (result) in
                DispatchQueue.main.async {
                    if(result){
                        self.showSendSuccess()
                    }else{
                        AlterView.showConnectServerError()
                    }
                }
            })
        }
        return true
    }

    func showSendSuccess() {
        LoadingView().stopAnimation()
        tipsLabel.isHidden = true
        let alertView = BHAlertView(frame: (UIApplication.shared.keyWindow?.frame)!)
        alertView.initAlertContent("", message: Localizaed("Avtived Email Send Success"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }

}
