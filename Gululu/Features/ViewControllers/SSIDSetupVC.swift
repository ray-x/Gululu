
//
//  SSIDSetupUI.swift
//  Gululu
//
//  Created by Ray Xu on 16/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import CoreData

class SSIDSetupVC: BaseViewController, UITextFieldDelegate, BHAlertViewDelegate {

    @IBOutlet weak var SSIDTextField: UITextField!
    @IBOutlet weak var WiFiPasswd: UITextField!
    @IBOutlet weak var visibilityImageView: UIImageView!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var WifiTitle: UILabel!
    @IBOutlet weak var TopTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    let helper = PairCupHelper.share
    
    var shouldRemove: Bool! = false
    let connStatus = NetworkStatusNotifier()
    var upHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSSIDSetupView()
        shouldRemove = true
        
        WifiTitle.text = helper.getPairTitleFromPage(-1)
        WiFiPasswd.placeholder = Localizaed("Enter wifi password")
        nextButton.setTitle(NEXT, for: .normal)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadViewWithSSID()
        notificationKeyboard()
        addWifiNotication()
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont(name: BASEBOLDFONT,size: 18) as Any, NSAttributedStringKey.foregroundColor:UIColor.white]

        if Common.isRunOnSimulator() { return }
        
        switch connStatus.connectionStatus() {
            case .unknown, .offline, .online(.wwan):
                stopNotifier()
                NetworkStatusNotifier().monitorNetworkChanges()
            case .online(.wiFi):
                break
        }
        
        WiFiPasswd.becomeFirstResponder()

	}
    
    func notificationKeyboard() {
        NotificationCenter.default.addObserver(self,selector:#selector(SSIDSetupVC.keyboardWillShow(_:)),name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.addObserver(self,selector:#selector(SSIDSetupVC.keyboardWillHide(_:)),name:NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    func addWifiNotication() {
        shouldRemove = true
        NotificationCenter.default.addObserver(self, selector: #selector(SSIDSetupVC.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: NetworkStatusChangedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SSIDSetupVC.reloadViewWithSSID), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender:Notification) {
        //
        print(nextButton.frame)
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print(keyboardSize.height)
                let needUpFloat = SCREEN_HEIGHT - nextButton.frame.height - nextButton.frame.origin.y - keyboardSize.height
                if needUpFloat <= 0 && upHeight == 0{
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.frame.origin.y -= -needUpFloat + 10
                        self.upHeight = needUpFloat - 10
                    })
                }

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
            if self.upHeight != 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y += -self.upHeight
                    self.upHeight = 0
                })
            }
        })
    }
    
    // MARK: - Layout SSIDSetupVC
    fileprivate func layoutSSIDSetupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePasswordSecure))
        visibilityImageView.isUserInteractionEnabled = true
        visibilityImageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func layoutTipButtonView(_ is5G: Bool, isGululuAP: Bool) {
        tipButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tipButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 0.0)
        
        if is5G {
            tipButton.setTitleColor(UIColor(white: 1.0, alpha: 1.0), for: .normal)
            tipButton.setTitle(Localizaed("5GHz Wi-Fi is not supported"), for: .normal)
            tipButton.setImage(UIImage(named: "warning_shape"), for: .normal)
        } else {
            if isGululuAP {
                tipButton.setTitleColor(UIColor(white: 1.0, alpha: 0.8), for: .normal)
                tipButton.setTitle(Localizaed("It is not a home Wi-Fi"), for: .normal)
                tipButton.setImage(UIImage(named: "warning_shape"), for: .normal)
            } else {
                tipButton.setTitleColor(UIColor(white: 1.0, alpha: 0.8), for: .normal)
                tipButton.setTitle(Localizaed("Wi-Fi network compatibility"), for: .normal)
                tipButton.setImage(UIImage(named: "info_shape"), for: .normal)
            }
        }
    }
    
    @objc fileprivate func reloadViewWithSSID() {
        helper.resetAllGululuData()
        SSIDTextField.text = helper.gululuSsid
        if helper.userSelectWifiPassword != nil{
            WiFiPasswd.text = helper.userSelectWifiPassword
        }
        layoutTipButtonView(helper.contain5G, isGululuAP: helper.isGululuAP)
    }
    
    @objc fileprivate func handlePasswordSecure() {
        WiFiPasswd.isSecureTextEntry = !WiFiPasswd.isSecureTextEntry
        WiFiPasswd.resignFirstResponder()
        
        if WiFiPasswd.isSecureTextEntry {
            visibilityImageView.image = UIImage(named: "visibilityOff")
        } else {
            visibilityImageView.image = UIImage(named: "visibilityOn")
        }
//        WiFiPasswd.clearsOnBeginEditing = WiFiPasswd.isSecureTextEntry
    }
    
    // MARK: TapGestures' Events
    @IBAction func ssidHiddenButtonAction(_ sender: AnyObject) {
    }
    
    // MARK: - Tap TipButton Action
    @IBAction func tipButtonAction(_ sender: AnyObject) {
        tipButtonShowAlertView()
    }
    
    fileprivate func tipButtonShowAlertView() {
        if helper.contain5G {
            showNoSupport5G()
        } else {
            if helper.getIsGluluAPBoolValue() {
                showNotHomeWifi()
            } else {
                showIncompatibleWiFi()
            }
        }
    }
    
    // MARK: - UITextfield Delegate
    @IBAction func textEditingChanged(_ sender: Any) {
        if WiFiPasswd.text?.count > 0 && WiFiPasswd.text?.count < 5{
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }else{
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        WiFiPasswd.font = UIFont(name: BASEFONT, size: 18.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return checkGotoConnectWifiCorrect()
    }

    fileprivate func stopNotifier() {
        if shouldRemove{
            shouldRemove = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NetworkStatusChangedNotification), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        }
    }
    
    func checkGotoConnectWifiCorrect() -> Bool{
        if SSIDTextField.text!.isEmpty {
            if !Common.isRunOnSimulator() { return false }
        }
        
        if helper.contain5G {
            showNoSupport5G()
            return false
        } else {
            if helper.getIsGluluAPBoolValue() {
                showNotHomeWifi()
                return false
            } else {
                if WiFiPasswd.text?.count == 0{
                    checkIsWifiNoNeedWifi()
                    return false
                }
                if WiFiPasswd.text?.count > 0 && WiFiPasswd.text?.count < 5{
                    return false
                }
                PairService.syncTimeZone({ ( _ ) in })
                return true
            }
        }
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        if checkGotoConnectWifiCorrect(){
           gotoNextVC()
        }
    }
    
    func gotoNextVC() {
        helper.userSelectWifiName  = SSIDTextField.text!
        helper.userSelectWifiPassword = WiFiPasswd.text!
        goto(vcName: "ConectingVerfyVC", boardName: "PairCup")
    }
    
    func showNoSupport5G() {
         showAlertViewOnSSIDVC(Localizaed("5GHz Wi-Fi is not supported"), message: Localizaed("Based on the Wi-Fi name, you might be connecting to an unsupported 5GHz Wi-Fi. Would you like to continue?"), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Continue"))
    }
    
    func showNotHomeWifi() {
        showAlertViewOnSSIDVC(Localizaed("It is not a home Wi-Fi"), message: Localizaed("Please connect to your home Wi-Fi first. The Wi-Fi name and password will be used to grant Gululu access to the Internet."), leftBtnTitle: GOTIT, rightBtnTitle: "")
    }
    
    func checkIsWifiNoNeedWifi() {
        showAlertViewOnSSIDVC(Localizaed("Are you sure about connecting to this wifi without a password?"), message: "", leftBtnTitle: CANCEL, rightBtnTitle:OK)
    }
    
    func showIncompatibleWiFi()  {
        showAlertViewOnSSIDVC(Localizaed("Incompatible Wi-Fi networks"), message: Localizaed("- 5GHz Wi-Fi network\r\n- Hidden Wi-Fi network\r\n- Wi-Fi network that require captive portal authentication"), leftBtnTitle: GOTIT, rightBtnTitle:"")

    }
    
    func showAlertViewOnSSIDVC(_ title: String, message: String, leftBtnTitle: String, rightBtnTitle: String) {
        let alertView = BHAlertView(frame: view.frame)
        alertView.delegate = self
        alertView.initAlertContent(title, message: message, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle)
        alertView.presentBHAlertView()
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    // MARK: - BHAlerView Delegate
    
    func rightButtonDelegateAction() {
        gotoNextVC()
    }
    
}

extension SSIDSetupVC {
    
    // MARK: - Network Status Changed Notification Event
    @objc fileprivate func networkStatusChanged(_ notification: Notification) {
        let networkStr = (notification as NSNotification).userInfo!["Status"] as! String
        
        if networkStr.contains("WiFi") {
            helper.getSSIDFromCon()
            SSIDTextField.text = helper.gululuSsid
        }
    }
}
