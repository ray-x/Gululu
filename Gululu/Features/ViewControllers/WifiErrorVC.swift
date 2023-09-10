//
//  WifiErrorVC.swift
//  Gululu
//
//  Created by Wei on 16/8/24.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

enum WifiErrStatus: Int {
    case passwordError      = 0
    case unsupportedWifi    = 1
    case unstableWifi       = 2
}

class WifiErrorVC: BaseViewController {

    @IBOutlet weak var titleTips: UILabel!
    @IBOutlet weak var tipDetailLabel: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    var wifiErrStatus: WifiErrStatus = .unstableWifi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retryButton.setTitle(Localizaed("Retry"), for: .normal)
        if wifiErrStatus ==  .unsupportedWifi {
            titleTips.text = Localizaed("Pair_not_connect_service_title")
            tipDetailLabel.text = Localizaed("Pair_not_connect_service_tips")
        } else if wifiErrStatus ==  .passwordError {
            titleTips.text = Localizaed("Pair_not_connect_wifi_tite")
            tipDetailLabel.text = Localizaed("Pair_not_connect_wifi_tips")
        } else if wifiErrStatus ==  .unstableWifi {
            titleTips.text = Localizaed("Pair_not_connect_wifi_tite")
            tipDetailLabel.text = Localizaed("Pair_not_connect_wifi_tips")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func retryButtonAction(_ sender: AnyObject) {
        for vc in (navigationController?.viewControllers)! {
            if vc.isKind(of: SSIDSetupVC.self) {
                _ = navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
