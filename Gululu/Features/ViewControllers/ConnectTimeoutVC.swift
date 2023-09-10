//
//  ConnectTimeoutVC.swift
//  Gululu
//
//  Created by Wei on 16/8/23.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class ConnectTimeoutVC: BaseViewController, BHAlertViewDelegate {
//    @IBOutlet weak var tipButton: UIButton!
    
    @IBOutlet weak var connectFailedLabel: UILabel!
    
    @IBOutlet weak var failedInfo: UILabel!
    fileprivate var buttonType: WifiErrStatus = .passwordError
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectFailedLabel.text = Localizaed("Connection failed :(")
        failedInfo.text = Localizaed("Please select the error icon you got on the bottle screen:")
//        tipButton.setTitle(Localizaed("I didn’t get these icons."), for: .normal)
//        tipButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -40.0, 0.0, 0.0)
//        tipButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 194.0, 0.0, 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        hideNavigation()
    }
    
    @IBAction func wifiErrorAction(_ sender: AnyObject) {
        buttonType = .passwordError
        gotoWifiErrorVC()
    }
    
    @IBAction func wifiNotFoundAction(_ sender: AnyObject) {
        buttonType = .unsupportedWifi
        gotoWifiErrorVC()
    }
    
    @IBAction func tipButtonAction(_ sender: AnyObject) {
        buttonType = .unstableWifi
        gotoWifiErrorVC()
    }
    
    @IBAction func abortButtonAction(_ sender: AnyObject) {
        let alertView = BHAlertView(frame: view.frame)
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Abort connecting?"), message: Localizaed("Without connection to Gululu, your child’s water drinking behavior won’t be recorded. You can still do it in the app sometime later."), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Abort"))
        alertView.presentBHAlertView()
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    
    // MARK: - BHAlertView Delegate
    func rightButtonDelegateAction() {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = navigationController?.viewControllers[0]
        
        if rootVC!.isKind(of: MainVC.self) {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            transition.type = kCATransitionReveal
            transition.subtype  = kCATransitionFromBottom
            navigationController?.view.layer.add(transition, forKey: nil)
            _ = navigationController?.popToRootViewController(animated: false)
        } else {
            let mainVC: MainVC = mainSB.instantiateViewController(withIdentifier: "showMainVC") as! MainVC
            mainVC.helper.childrenDisplayed = true
            navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    func gotoWifiErrorVC() {
        let SB = UIStoryboard(name: "PairCup", bundle: nil)
        let VC: WifiErrorVC = SB.instantiateViewController(withIdentifier: "WifiErrorVC") as! WifiErrorVC
        VC.wifiErrStatus = buttonType
        self.navigationController?.pushViewController(VC, animated: true)
    }

}
