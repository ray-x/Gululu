//
//  IntroVC.swift
//  Gululu
//
//  Created by Baker on 16/7/14.
//  Copyright © 2016年 w19787. All rights reserved.
//

import UIKit

class IntroVC : BaseViewController {

    @IBOutlet weak var infoTitle: UILabel!
    
    @IBOutlet weak var infoDetail: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GUser.share.isChildCreated = false
        infoTitle.text = Localizaed("Set up Gululu for your child")
        infoDetail.text = Localizaed("To get an accurate picture of your child's drinking activity, please tell us a few things about your child.")
        goButton.setTitle(Localizaed("Let's\rgo"), for: .normal)
        goButton.titleLabel?.textAlignment = .center
        
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @IBAction func gotoNameVC(_ sender: AnyObject) {
        goto(vcName: "NameVC", boardName: "Register")
    }
}
