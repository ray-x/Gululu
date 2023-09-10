//
//  PrivacyVC.swift
//  Gululu
//
//  Created by baker on 2018/6/13.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

class PrivacyVC:  BaseViewController , UITextViewDelegate, UIWebViewDelegate{

    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var weibView: UIWebView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tips: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var agreebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBtn.setTitle(CANCEL, for: .normal)
        agreebtn.setTitle(Localizaed("Agree"), for: .normal)
        agreebtn.isEnabled = false
        checkButton.setImage(UIImage(named: "check_box_normal"), for: .normal)
        checkButton.setImage(UIImage(named: "check_box_selected"), for: .selected)
        titleView.text = Localizaed("Terms of Use") + " & " + Localizaed("Privacy Policy")
        tips.isEditable = false
        tips.delegate = self
        setTips()
        
        weibView.scrollView.bounces = false
        weibView.loadRequest(URLRequest(url: URL(string: terms_and_privacy_web_url)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        LoadingView().beginAnimation()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingView().stopAnimation()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LoadingView().stopAnimation()
    }

    func setTips() {
        GULabelUtil.setPrivacyVCTips(tips)
    }
    
    @IBAction func check(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        agreebtn.isEnabled = checkButton.isSelected
    }
    
    @IBAction func cancleAc(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func agreeAc(_ sender: Any) {
        if(checkButton.isSelected){
            gotoLogin()
        }
    }
    
    func gotoLogin(){
        let storyboard = UIStoryboard(name:"Login", bundle: nil)
        let loginVC : LoginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
        if Common.checkPreferredLanguages() == 1{
            loginVC.vcModel = .inputPhoneNumber
        }else{
            loginVC.vcModel = .inputEmail
        }
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL.absoluteString)
        if URL.absoluteString == "file:///showPrivacy"{
            let broswerView = BrowserViewController()
            broswerView.webURL = privacy_web_url
            present(broswerView, animated: true, completion: nil)
        }else if URL.absoluteString == "file:///showTerms"{
            let broswerView = BrowserViewController()
            broswerView.webURL = terms_web_url
            present(broswerView, animated: true, completion: nil)
        }
        return true
    }
}
