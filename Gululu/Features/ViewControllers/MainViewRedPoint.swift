//
//  MainViewRedPoint.swift
//  Gululu
//
//  Created by baker on 2018/8/24.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import Foundation

extension MainVC {
    
    //friend
    func check_out_add_friend_message_show_red_sign() {
        FriendHelper.share.query_pending_fiends { (result) in
            DispatchQueue.main.async {
                if FriendHelper.share.check_show_friend_red_sing(){
                    FriendHelper.share.save_click_friend_button_para(false)
                    self.show_friend_red_sign()
                }else{
                    self.remove_red_sign_in_friend_button()
                }
            }
        }
    }
    
    // MARK: - Helpshift
    func checkoutShowRedSignInHelpshiftButton()  {
        if helper.isShouldShowNewRedSign(){
            addRedSignInHelpshiftButton(helpshiftMessageButton)
            DispatchQueue.main.async {
                self.addRedSignInHelpshiftButton(self.helpshiftMessageButton)
                self.helpShiftButtonAnimation()
            }
        }
    }
    
    // setting button
    func checkAddRedSignInSettingButton() {
        if CupInfoHelper.share.cupConnectTimeLastThreeDays{
            addRedSignInHelpshiftButton(settingButton)
        }else{
            removeRedSignView(settingButton)
        }
    }
    
    func show_view_red_sign(_ addSubView: UIView, pointTag: Int) -> UIView{
        var redSignView : UIView? = addSubView.viewWithTag(pointTag)
        if redSignView == nil{
            redSignView = UIView()
            redSignView!.tag = pointTag
            addSubView.addSubview(redSignView!)
        }else{
            redSignView?.isHidden = false
        }
        return redSignView!
    }
    
    func show_friend_red_sign(){
        let redSignView : UIView = show_view_red_sign(friendButton, pointTag: main_friend_button_red_sign_tag)
        redSignView.snp.makeConstraints{ (view) in
            view.top.equalTo(friendButton).offset(5)
            view.right.equalTo(friendButton).offset(-10)
            view.size.equalTo(CGSize(width: 15, height: 15))
        }
        setRedSignView(redSignView)
    }
    
    func remove_red_sign_in_friend_button() {
        let redSignView : UIView? = friendButton.viewWithTag(main_friend_button_red_sign_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }
    
    func addRedSignInPetButton() {
        let redSignView : UIView = show_view_red_sign(petButton, pointTag: main_pet_button_red_sing_tag)
        redSignView.snp.makeConstraints{ (view) in
            view.top.equalTo(petButton).offset(10)
            view.right.equalTo(petButton).offset(-5)
            view.size.equalTo(CGSize(width: 15, height: 15))
        }
        setRedSignView(redSignView)
    }
    
    func setRedSignView(_ redSignView: UIView?)  {
        redSignView?.backgroundColor = .red
        redSignView?.layer.masksToBounds = true
        redSignView?.layer.cornerRadius = 7.5
        redSignView?.layer.borderColor = UIColor.white.cgColor
        redSignView?.layer.borderWidth = 3.0
    }
    
    func addRedSignInHelpshiftButton(_ button : UIButton) {
        let redSignView : UIView = show_view_red_sign(button, pointTag: main_helpshift_red_sign_tag)
        redSignView.snp.makeConstraints{ (view) in
            view.top.equalTo(button).offset(19)
            view.right.equalTo(button).offset(-14)
            view.size.equalTo(CGSize(width: 15, height: 15))
        }
        setRedSignView(redSignView)
    }
    
    func removeRedSignFromPetButton() {
        let redSignView : UIView? = petButton.viewWithTag(main_pet_button_red_sing_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }
}
