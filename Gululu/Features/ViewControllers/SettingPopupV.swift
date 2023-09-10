//
//  SettingPopupV.swift
//  Gululu
//
//  Created by Ray Xu on 25/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
////import Flurry_iOS_SDK

@IBDesignable class SettingPopupV: UIView,HelpshiftSupportDelegate {
    
    var configView:UIView!
    var container:MainVC!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avator: ImageMaskView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var tutorilaLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    
    var upgradeButton : UIButton?
    var petImage : UIImageView?
    var newSignLabel : UILabel?
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SettingPopupV", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0]
        return view as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    func xibSetup() {
        
        configView = loadViewFromNib()
        configView.frame = bounds
        configView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        configView.layer.shadowRadius = 11
        configView.layer.shadowOpacity = 0.5
        configView.layer.shadowColor = UIColor.clear.cgColor
        addSubview(configView)
        
        let tapGeR = UITapGestureRecognizer()
        tapGeR.numberOfTapsRequired = 1
        tapGeR.addTarget(self, action: #selector(showAlterChildInfoVC(_:)))
        avator.addGestureRecognizer(tapGeR)
        
        profileLabel.text = Localizaed("Profile")
        settingLabel.text = Localizaed("Setting")
        helpLabel.text = Localizaed("Help")
        tutorilaLabel.text = Localizaed("Tutorial")
        
        HelpshiftSupport.sharedInstance().delegate = self
    }
    
    func viewWillAppearEveryOnce() {
        load_helpshift_message_count()
        layAvatorImage()
        reloadUpgradeButton()
    }
    
    func load_helpshift_message_count() {
        HelpshiftSupport.requestUnreadMessagesCount(true)
    }
    
    func layAvatorImage() {
        let imagePath: String! = activeChildID + ".jpg"
        avator.imagePath = imagePath
        avator.layoutSubviews()
    }
    
    func reloadUpgradeButton() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeObverserverUpgrade), name: NSNotification.Name(rawValue: PetStatusNotifacationName), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeNewSignObverserver), name: NSNotification.Name(rawValue: newSignObserverNotiStr), object: nil)
        
        
        MainUpgrade.shareInstance.checkUpgradePetStatus(activeChildID)
        
        DeviceInfoHelper.share.checkAndGetChildDeviceInfo()
        
        checkLoadUpgradeButton()
        
        addRedSignInSettingButton()
    }
    
    @objc func removeObverserverUpgrade() {
        checkLoadUpgradeButton()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PetStatusNotifacationName), object: nil)
    }
    
    @objc func removeNewSignObverserver() {
        addRedSignInSettingButton()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: cupStatusNoticationName), object: nil)
    }
    
    func checkLoadUpgradeButton() {
        DispatchQueue.main.async {
            if GUser.share.activeChild?.hasCup == 0{
                self.upgradeButton?.isHidden = true
                self.petImage?.isHidden = true
                return
            }
            switch MainUpgrade.shareInstance.petGradeStatus {
            case .upgrading, .ready, .require, .downloading:
                self.createUpgradeView()
            default:
                self.upgradeButton?.isHidden = true
                self.petImage?.isHidden = true
                return
            }
        }
    }
    
    func loadScrollerViewUpgradeSize() {
        scrollView.contentSize = CGSize(width: self.configView.frame.width, height: self.configView.frame.height + 50)
    }
    
    func createUpgradeView() {
        if upgradeButton == nil{
            let width = Common.getLabWidth(labelStr: MainUpgrade.shareInstance.getPetUpgradeStatusStr(), font: UIFont(name: BASEBOLDFONT, size: 18)!, height: 60)
            upgradeButton = UIButton(frame: CGRect(x: 18, y:SCREEN_HEIGHT - 76, width: width + 55 , height: 60))
            upgradeButton?.titleLabel?.numberOfLines = 0
            upgradeButton?.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 18)
            upgradeButton?.titleLabel?.textAlignment = .left
            upgradeButton?.setTitleColor(UIColor(red: 63/255, green: 189/255, blue: 174/255, alpha: 1), for: .normal)
            upgradeButton?.backgroundColor = .white
            upgradeButton?.layer.opacity = 0.95
            upgradeButton?.layer.masksToBounds = true
            upgradeButton?.layer.cornerRadius = 4.0
            upgradeButton?.isHidden = false
            upgradeButton?.addTarget(self, action: #selector(showUpgradeView(_:)), for: .touchUpInside)
            
        }
        if petImage == nil{
            let width = 150/375*SCREEN_WIDTH
            petImage = UIImageView(frame: CGRect(x: frame.width - width*0.8, y: frame.height - width*0.8, width: width, height: width))
            petImage?.isHidden = false
        }
        upgradeButton?.isHidden = false
        petImage?.isHidden = false
        upgradeButton?.setTitle(MainUpgrade.shareInstance.getPetUpgradeStatusStr(), for: .normal)
        upgradeButton?.setImage(UIImage(named: MainUpgrade.shareInstance.getPetUpgradeImageStr()), for: .normal)
        petImage?.image = UIImage(named: MainUpgrade.shareInstance.getPetImageNameStr())
        setButtonStyle(button: upgradeButton!)
        addSubview(upgradeButton!)
        addSubview(petImage!)
    }
    
    func setButtonStyle(button:UIButton) {
        button.setleftImage(3.0)
    }
    
    @objc func showUpgradeView(_ sender : UIButton) {
        
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let upgradeView = mainSB.instantiateViewController(withIdentifier: "upgrade")
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        container.navigationController?.view.layer.add(transition, forKey: nil)
        container.navigationController?.pushViewController(upgradeView, animated: false)
        
    }
    
    func addRedSignInSettingButton() {
        if CupInfoHelper.share.cupConnectTimeLastThreeDays{
            var redSignView : UIView? = settingButton.viewWithTag(main_helpshift_red_sign_tag)
            if redSignView == nil{
                redSignView = UIView()
                redSignView!.tag = main_helpshift_red_sign_tag
                settingButton.addSubview(redSignView!)
                redSignView!.snp.makeConstraints{ (view) in
                    view.top.equalTo(settingButton).offset(0)
                    view.right.equalTo(settingButton).offset(3)
                    view.size.equalTo(CGSize(width: 20, height: 20))
                }
                redSignView?.backgroundColor = .red
                redSignView?.layer.masksToBounds = true
                redSignView?.layer.cornerRadius = 10
                redSignView?.layer.borderColor = UIColor.white.cgColor
                redSignView?.layer.borderWidth = 4.0
            }else{
                redSignView?.isHidden = false
            }
        }else{
            removeRedSign(settingButton)
        }
    }
    
    func removeRedSign(_ view : UIView) {
        let redSignView : UIView? = view.viewWithTag(main_helpshift_red_sign_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }
    
    @objc func showAlterChildInfoVC(_ sender: UIGestureRecognizer){
        MianVCHepler.share.successHander = .childInfoHander
        container.checkoutParentLockView()
    }
    
    
    @IBAction func ShowSettingSeg(_ sender: UIButton) {
        MianVCHepler.share.successHander = .settingHander
        container.checkoutParentLockView()
    }
    
    @IBAction func gotoTutorialVC(_ sender: Any) {
        //Flurry.logEvent("tutorial_click")
        TutorialHelper.share.enterType = .settingVcIn

        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let upgradeView = mainSB.instantiateViewController(withIdentifier: "tutorial")
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        container.navigationController?.view.layer.add(transition, forKey: nil)
        container.navigationController?.pushViewController(upgradeView, animated: false)
    }
    
    @IBAction func helpAction(_ sender: AnyObject) {
        if Common.checkPreferredLanguagesIsEn(){
            MianVCHepler.share.successHander = .helpshiftHander
            container.checkoutParentLockView()
        }else{
            container.showHelpshiftContanier()
        }
    }
    
    func didReceiveNotificationCount(_ count: Int) {
        handleCount(count)
    }
    
    func didReceiveUnreadMessagesCount(_ count: Int) {
        handleCount(count)
    }
    
    func handleCount(_ count:Int) {
        DispatchQueue.main.async {
            if count == 0{
                self.removeHelpshiftRedSign(self.helpButton)
                return
            }
            var redSignLabel : UILabel? = self.viewWithTag(setting_helpshift_tag) as! UILabel?
            if redSignLabel == nil{
                redSignLabel = UILabel()
                redSignLabel!.tag = setting_helpshift_tag
                self.helpButton.addSubview(redSignLabel!)
                redSignLabel!.snp.makeConstraints{ (view) in
                    view.top.equalTo(self.helpButton).offset(0)
                    view.right.equalTo(self.helpButton).offset(3)
                    view.size.equalTo(CGSize(width: 32, height: 32))
                }
                redSignLabel?.backgroundColor = .red
                redSignLabel?.layer.masksToBounds = true
                redSignLabel?.layer.cornerRadius = 16
                redSignLabel?.layer.borderColor = UIColor.white.cgColor
                redSignLabel?.layer.borderWidth = 5.0
                redSignLabel?.font = UIFont(name: BASEBOLDFONT, size: 18)
                redSignLabel?.textColor = .white
                redSignLabel?.textAlignment = .center
            }else{
                redSignLabel?.isHidden = false
            }
            redSignLabel?.text = String(count)
        }
    }
    
    func removeHelpshiftRedSign(_ view : UIView) {
        let redSignView : UIView? = view.viewWithTag(setting_helpshift_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }
    
}
