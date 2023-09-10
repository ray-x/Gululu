//
//  LaunchWelcome.swift
//  Gululu
//
//  Created by Baker on 2017/10/26.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class LaunchWelcome: BaseViewController, BHAlertViewDelegate {

    
    @IBOutlet weak var joinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinBtn.setTitle(Localizaed("Join us"), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinus(_ sender: Any) {
        check_server()
    }
    
    func gotoMainVC() {
        goto(vcName: "showMainVC", boardName: "Main")
    }
    
    func check_server() {
        LoadingView().showLodingInView()
        if !isConnectNet(){
            LoadingView().stopAnimation()
            showCheckUserAccountFaied_no_network()
            return
        }
        GUserConfigUtil.share.checkout_health_in_feature_config{ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result {
                    self.gotoPrivacyView()
                }else{
                    self.show_server_no_ok()
                }
            }
        }
    }
    
    func gotoPrivacyView() {
        let mainSB = UIStoryboard(name: "Login", bundle: nil)
        let vc: PrivacyVC = mainSB.instantiateViewController(withIdentifier: "PrivacyID") as! PrivacyVC
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func show_server_no_ok() {
        let alertView = BHAlertView(frame: self.view.frame)
        LoginHelper.share.login_alter_tag = login_check_account_failed
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Please check your internet connection."), message:  Localizaed("- 1.Make sure the network connection is normal\r\n- 2.The server may be disconnected，Please contact customer service."), leftBtnTitle: OK, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func showCheckUserAccountFaied_no_network() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: self.view.frame)
        LoginHelper.share.login_alter_tag = login_check_account_failed
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Please check your internet connection."), message:  Localizaed("Confirm the system settings agree that Gululu uses WLAN & Cellular Data"), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Go to setting"))
        alertView.presentBHAlertView()
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
    
    func cancleButtonDelegateAction() {
        //
    }

}
