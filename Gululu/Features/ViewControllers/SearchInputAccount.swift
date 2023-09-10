//
//  SearchInputAccount.swift
//  Gululu
//
//  Created by Baker on 2017/10/30.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

class SearchInputAccount: BaseViewController, UITextFieldDelegate {

    let helper = FriendHelper.share

    @IBOutlet weak var input_account: TintTextField!
    @IBOutlet weak var search_titile: UILabel!
    @IBOutlet weak var search_button: UIButton!
    @IBOutlet weak var tip_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search_titile.text = Localizaed("Search friends")
        search_button.setTitle(Localizaed("Search"), for: .normal)
        remove_no_account_tips()
        let placeholder = Localizaed("Enter phone number or Email")
        input_account.placeholder = placeholder
        input_account.delegate = self
        input_account.clearButtonMode = .whileEditing
        input_account.attributedPlaceholder =  NSAttributedString(string: placeholder, attributes:[NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 255, blue: 255, alpha: 0.5), NSAttributedStringKey.font : UIFont(name: BASEFONT, size: 20) as Any])
        button_cannot_click(search_button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        //Flurry.logEvent("SearchFriendBtn")
        if !checkInternetConnection(){
           return
        }
        LoadingView().showLodingInView()
        helper.search_account = input_account.text!
        helper.serach_friend_by_user_account(input_account.text!) { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result == 2{
                    self.show_no_account_tips()
                }else if result == 1{
                    self.goto_result_page()
                }else{
                    GHHttpHelper.show_server_error()
                }
            }
        }
    }
    
    func show_search_failed() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("Search failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    @IBAction func input_change(_ sender: Any) {
        if Common.isValidEmail(input_account.text!) || Common.isValidMobile(input_account.text!){
            remove_no_account_tips()
            button_can_click(search_button)
        }else{
            button_cannot_click(search_button)
        }
    }
    
    func remove_no_account_tips() {
        tip_label.isHidden = true

    }
    
    func show_no_account_tips() {
        tip_label.isHidden = false
        tip_label.text = Localizaed("The account does not exist, please enter the correct account!")
    }
    
    func goto_result_page(){
        goto(vcName: "SearchResault", boardName: "FriendsVC")
    }

}
