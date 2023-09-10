//
//  MainVC.swift
//  Gululu
//
//  Created by Ray Xu on 12/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import SnapKit
import DOUAudioStreamer
////import Flurry_iOS_SDK


class MainVC: BaseViewController, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate, BHMaskViewDelegate, AddChildViewDelegate, BHAlertViewDelegate, UIScrollViewDelegate, HelpshiftInboxDelegate, UMSocialShareMenuViewDelegate{
    
    @IBOutlet weak var photoMaskView: UIView!
    @IBOutlet weak var profileImageView: ImageMaskView!
    @IBOutlet weak var backgroundView: FLAnimatedImageView!
    @IBOutlet weak var viewVolButton: UIButton!
    @IBOutlet weak var petImageView: FLAnimatedImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var unitL: UILabel!
    @IBOutlet weak var choosePetTipLabel: UILabel!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var petButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var helpshiftMessageButton: UIButton!
    @IBOutlet weak var addBottleButton: UIButton!
    @IBOutlet weak var pet_story_sign: FLAnimatedImageView!
    @IBOutlet weak var pet_story_sign_bg: FLAnimatedImageView!
    @IBOutlet weak var habit_score_button: UIButton!
    @IBOutlet weak var child_name_height: NSLayoutConstraint!
    @IBOutlet weak var child_pet_cup_level: UILabel!
    
    
    var addChildrenView: AddChildView!
    var waterBarView: WaterBarChart?
    var configurePopup: SettingPopupV!
    var bootPage: BootPageVC?
    
    let lock = ParentLockView()

    var waterWave : WaterLayerView?
    let backView    = UIView()
    let changePetScrollerView = UIScrollView()
    
    let helper = MianVCHepler.share

    // MARK: - ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getAPIVersion()
        layoutNavigationController()
        layoutMainView()
        layoutBackView()
        helper.childrenDisplayed = false
        loadFirstPetInMainVC()
        getChildPhotoURL()
        updateHabites()
        checkChildPetSwitch()
        setViewVoulButtonStyle(per: 0)
        Crashlytics.sharedInstance().setUserEmail(GUser.share.email)
        Crashlytics.sharedInstance().setUserIdentifier(GUser.share.getUserSn())
        setHelpShiftDelegate()
        main_view_imageView_add_tap_gesture()
        checkoutShowRedSignInHelpshiftButton()
        get_child_pet_cup_level()
        setUserNoticaion()
    }
    
    func setUserNoticaion() {
        appDelegate.setUserNotifacation(UIApplication.shared, launchOptions: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(app2Forground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMainUpgradeView), name: NSNotification.Name(rawValue: PetStatusNotifacationName), object: nil)
        
        if GUser.share.appStatus != .main {
            GUser.share.updateChildList()
        }
        if GUser.share.appStatus == .deleteChild{
           updateActiveChild(0)
        }
        if GUser.share.appStatus == .changeProfile || GUser.share.appStatus == .addChild{
            updateChildAvatar()
            updateHabites()
        }
        if GUser.share.appStatus == .registered || GUser.share.appStatus == .addChild {
            if GUser.share.workingChild != nil {
                GUser.share.workingChild = nil
            }
        }

        if addChildrenView != nil {
            addChildrenView.childrenList  = GUser.share.childList as NSArray
            addChildrenView.childrenCollectionView.reloadData()
        }

        if GUser.share.appStatus == .addPet ||  GUser.share.appStatus == .addChild {
            displayCurrentPet()
        }
        
        if GUser.share.appStatus == .changePet && GPet.share.chosePetSucced == true {
            displayCurrentPet()
        }
        
        if GUser.share.appStatus == .addChild {
            isNeedLoadBHMaskView()
        }
        
        if GUser.share.appStatus == .upgradePet && configurePopup != nil{
            configurePopup.reloadUpgradeButton()
        }
        
        loadDirnkWaterLog(false)
        
        check_out_add_friend_message_show_red_sign()
        checkAddbottleButtonHidden()
        checkAddRedSignInSettingButton()
        loadHelpShiftCount()
        updateViewDataInfo()
        addBottleButtonSetSync()
        if GUser.share.appStatus == .bindCup{
            checkIfFirstTimePaired()
        }
        checkout_feature_config()
        get_child_pet_cup_level()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GUser.share.appStatus == .registered {
            isNeedLoadBHMaskView()
        }
        GUser.share.appStatus = .main
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        helper.addBottleButtonIsAnimation = false
    }
    
    //MARK： - Feature Config
    fileprivate func hidePetStoryItem() {
        pet_story_sign.isHidden = true
        pet_story_sign_bg.isHidden = true
    }
    
    func checkout_feature_config() {
        hidePetStoryItem()
        self.checkout_pet_stort_img_status()
        self.checkout_friend_button_status()
        GUserConfigUtil.share.checkout_health_in_feature_config{ result in
            DispatchQueue.main.async {
                self.checkout_pet_stort_img_status()
                self.checkout_friend_button_status()
            }
        }
    }
    
    func checkout_friend_button_status()  {
        if(GUserConfigUtil.share.checkout_add_frined()){
            friendButton.isEnabled = true
        }else{
            friendButton.isEnabled = true
        }
    }
    
    //MARK: - share score
    
    @IBAction func habitx_click_to_share(_ sender: Any) {
        //Flurry.logEvent("Main_habit_score_btn_click")
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let share_score: ShareScoreVC = mainSB.instantiateViewController(withIdentifier: "shareScore") as! ShareScoreVC
        view.addSubview(share_score.view)
                
        share_score.dissmissButton.addTarget(self, action: #selector(remove_share_score_view), for: .touchUpInside)
//        share_score.shareButton.addTarget(self, action: #selector(show_share_view), for: .touchUpInside)
        share_score.saveImageButton.addTarget(self, action: #selector(save_image_to_photo), for: .touchUpInside)
        share_score.share_score_view.tag = main_share_score_img_tag
    }
    
    func main_view_imageView_add_tap_gesture() {
        pet_story_sign.isUserInteractionEnabled = true
        let tapGesture_1 = UITapGestureRecognizer(target: self, action: #selector(goto_pet_story_view))
        pet_story_sign.addGestureRecognizer(tapGesture_1)
    }
    
    func checkout_pet_stort_img_status()  {
        if PetStoryHelper.share.can_show_pet_story_enter(){
            pet_story_sign.isHidden = false
            pet_story_sign_bg.isHidden = false
            if PetStoryHelper.share.streamer?.status == DOUAudioStreamerStatus.playing{
                let petFile = "pet_story_play"
                let URLPet = Bundle.main.url(forResource: petFile, withExtension: "gif")
                let dataPet = try? Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
                pet_story_sign.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
            }else{
                pet_story_sign.image = UIImage(named: "pet_story_play_btn")
            }
        }else{
            hidePetStoryItem()
        }
    }
    
    //pet story
    @objc func goto_pet_story_view() {
        //Flurry.logEvent("Main_pet_story_btn_click")
        if BaseHelper.base_share.pet_story_view == nil{
            let mainSB = UIStoryboard(name: "PetParadise", bundle: nil)
            BaseHelper.base_share.pet_story_view = mainSB.instantiateViewController(withIdentifier: "petStory") as? PetStoryVC
        }
        navigationPushView(BaseHelper.base_share.pet_story_view!)
       
    }
    
    @objc func remove_share_score_view(){
        for view:UIView in self.view.subviews {
            if view.tag == main_share_score_tag{
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func show_share_view(){
        ShareHelper.share.click_platformType = UMSocialPlatformType.unKnown
        //Flurry.logEvent("Main_habit_view_share_btn_click")
        for view:UIView in self.view.subviews {
            if view.tag == main_share_score_tag{
                for subView:UIView in view.subviews{
                    if subView.tag == main_share_score_img_tag{
                        ShareHelper.share.shareImage = Common.cutImageWithView(subView)
                    }
                }
            }
        }
//        show_share_view_in_window()
    }
    
    func show_share_view_in_window() {
//        UMSocialUIManager.setShareMenuViewDelegate(self)
//        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),
//                                                 NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue),
//                                                 NSNumber(integerLiteral:UMSocialPlatformType.sina.rawValue),
//                                                 NSNumber(integerLiteral:UMSocialPlatformType.facebook.rawValue),
//                                                 NSNumber(integerLiteral:UMSocialPlatformType.twitter.rawValue)]);
//        UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { (platformType,userinfo) in
//            let shareObject : UMSocialMessageObject = UMSocialMessageObject()
//            let shareimage : UMShareImageObject = UMShareImageObject()
//            shareimage.shareImage = ShareHelper.share.shareImage
//            shareObject.shareObject = shareimage
//            ShareHelper.share.click_platformType = platformType
//
//            UMSocialManager.default().share(to: platformType, messageObject: shareObject, currentViewController: self, completion: { (result , error) in
//                if result == nil{
//                    let logstr = String(format: "%d, %@", platformType.rawValue, error.debugDescription)
//                    BH_ERROR_LOG(logstr)
//                    if platformType == UMSocialPlatformType.facebook{
//                        return
//                    }
//                    let tips = Localizaed("Share failed!")
//                    BAlterTipView().load_view(tips, direction: 0)
//                }else{
//                    let tips = Localizaed("Share success!")
//                    BAlterTipView().load_view(tips, direction: 0)
//                }
//            })
//        })
    }
    
    func umSocialShareMenuViewDidDisappear() {
        if ShareHelper.share.click_platformType == UMSocialPlatformType.twitter{
            if NetConnect.isVPNConnected_VPN() == false{
                BH_ERROR_LOG("twitter no vpn share failed")
                let tips = Localizaed("Share failed!")
                BAlterTipView().load_view(tips, direction: 0)
            }
        }
    }
    
    @objc func save_image_to_photo() {
        for view:UIView in self.view.subviews {
            if view.tag == main_share_score_tag{
                for subView:UIView in view.subviews{
                     if subView.tag == main_share_score_img_tag{
                        let image = Common.cutImageWithView(subView)
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            }
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer){
        if let e = error as NSError?{
            print(e)
        } else {
            let tips = Localizaed("Saved successfully!")
            BAlterTipView().load_view(tips, direction: 0)
        }
    }
    
    //MARK: - Pet NOticaton
    func checkChildPetSwitch() {
        let childHasCup = GChild.share.check_current_child_have_cup()
        if GPetParadise.share.check_can_request_pet_switch(childHasCup){
            GPet.share.getNextPetsFromRemote { (result) in
                DispatchQueue.main.async {
                    self.removeObverserverCanSwitch()
                }
            }
        }else{
            removeRedSignFromPetButton()
        }
    }
    
    func removeObverserverCanSwitch() {
        if GPet.share.can_add_pet && helper.read_click_pet_button() == false{
            addRedSignInPetButton()
        }else{
            removeRedSignFromPetButton()
        }
    }
    
    // MARK: - Cupinfo
    func requestCupinfo() {
        NotificationCenter.default.addObserver(self, selector: #selector(removeNewSignObverserver), name: NSNotification.Name(rawValue: cupStatusNoticationName), object: nil)
        CupInfoHelper.share.checkCupConnectStatues()
        checkAddRedSignInSettingButton()
    }
    
    @objc func removeNewSignObverserver() {
        checkAddRedSignInSettingButton()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: cupStatusNoticationName), object: nil)
    }
 
    // MARK: - Helpshift
    func setHelpShiftDelegate() {
        HelpshiftInbox.sharedInstance().delegate = self
        positionDownAnimaiton()
    }
    
    func inboxMessageAdded(_ newMessage: HelpshiftInboxMessage!) {
        helper.saveNewInboxMessage()
        DispatchQueue.main.async {
            self.addRedSignInHelpshiftButton(self.helpshiftMessageButton)
            self.helpShiftButtonAnimation()
        }
    }
    
    func helpShiftButtonAnimation() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.redSignAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.redSignAnimation()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.redSignAnimation()
        }
    }
    
    func positionDownAnimaiton() {
        let myAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
        helpshiftMessageButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        helpshiftMessageButton.layer.add(myAnimation, forKey: nil)
    }
    
    func redSignAnimation() {
        
        let myAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
        myAnimation.isRemovedOnCompletion = false
        let left: CGFloat = CGFloat(-Double.pi/2) * 0.1
        let right: CGFloat = CGFloat(Double.pi/2) * 0.1
        
        myAnimation.keyPath = "position"
        myAnimation.keyPath = "transform.rotation"
        
        myAnimation.values = [(left),(right),(left)]
        myAnimation.duration = 0.1
        myAnimation.repeatCount = 8
        helpshiftMessageButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0.2)

        helpshiftMessageButton.layer.add(myAnimation, forKey: nil)
    }

    func inboxMessageDeleted(_ identifier: String!) {
        print("delete")
    }
    
    func inboxMessageMarked(asSeen identifier: String!) {
        print("seen")
        let message =  HelpshiftInbox.sharedInstance().getMessageForId(identifier)
        let image = message?.getCoverImage()
        ShareHelper.share.shareImage = image
    }
    
    func inboxMessageMarked(asRead identifier: String!) {
        print("read")
    }
    
    func failedToAddInboxMessage(withId identifier: String!) {
        print("failed")
    }
    
    @IBAction func showHelpInboxView(_ sender: Any) {
        MianVCHepler.share.successHander = .helpshiftBoxHander
        checkoutParentLockView()
    }
    
    func showInbox()  {
        removeRedSignView(helpshiftMessageButton)
        helper.saveReadNewInBoxMessage()
        HelpshiftCampaigns.showInbox(on: self, with: nil)
    }
    
    func removeRedSignView(_ button : UIButton) {
        let redSignView : UIView? = button.viewWithTag(main_helpshift_red_sign_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }
    
    // MARK: - Update View
    func loadFirstPetInMainVC() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.displayCurrentPet()
        }
    }
    
    func clearMermory() {
        backgroundView.animatedImage = FLAnimatedImage(animatedGIFData: nil)
        petImageView.animatedImage = FLAnimatedImage(animatedGIFData: nil)
        waterWave = nil
        addChildrenView = nil
        waterBarView = nil
        configurePopup = nil
        bootPage = nil
        BaseHelper.base_share.cancel_paly_view()
    }
    
    func checkAddbottleButtonHidden() {
        let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
        if childHasBotleState == .pet {
            addBottleButton.isHidden = false
            addBottleButton.layer.removeAllAnimations()
            helper.addBottleButtonIsAnimation = false
            addBottleButton.layer.cornerRadius = addBottleButton.frame.width/2 + 3
            addBottleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            addBottleButton.layer.shadowOpacity = 0.5
            addBottleButton.layer.shadowColor = UIColor.black.cgColor
            addBottleButton.layer.shadowRadius = 4.0
            addBottleButton.setImage(UIImage(named: "addBottle"), for: .normal)
        }else{
            addBottleButton.isHidden = true
        }
        if childHasBotleState == .both{
            requestCupinfo()
        }
    }
    
    func addBottleButtonSetSync() {
        let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
        if childHasBotleState == .both{
            if GPet.share.showPetStatus == .sync{
                addBottleShowSyncRotation()
            }else{
                addBottleButton.isHidden = true
            }
        }
    }
    
    @IBAction func addBottle(_ sender: Any) {
        if GPet.share.showPetStatus == .sync{
            showSyncView(addBottleButton)
        }else{
            checkChildPairSuccess()
        }
    }
    
    func isNeedLoadBHMaskView() -> Void {
        if GUser.share.addChildSucced{
            helper.childrenDisplayed = true
            hideDetailBarChart(UIGestureRecognizer())
            loadBHMaskView(addBottleButton.center)
        }
    }

    // MARK: - Layout MainView
    fileprivate func layoutNavigationController() {
        if (navigationController?.viewControllers.count > 1) {
            navigationController?.viewControllers.removeAll()
            navigationController?.setViewControllers([self], animated: false)
        }
    }
    
    fileprivate func layoutMainView() {
        petButton.setTitle(Localizaed("Pets"), for: .normal)
        friendButton.setTitle(Localizaed("Friends"), for: .normal)

        let bundle = Bundle.main
        let URL = bundle.url(forResource: "fish", withExtension: "gif")
        let data = try!  Data(contentsOf: URL!, options: NSData.ReadingOptions.mappedIfSafe)
        backgroundView.animatedImage = FLAnimatedImage(animatedGIFData:(data))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.loadChildren(_:)))
        photoMaskView.addGestureRecognizer(tapGesture)
        
        let hideBarGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideDetailBarChart(_:)))
        hideBarGesture.delegate = self
        backView.addGestureRecognizer(hideBarGesture)
        
        let tapPetGesture = UITapGestureRecognizer(target: self, action: #selector(self.petSelect(_:)))
        tapPetGesture.delegate = self
        petImageView.addGestureRecognizer(tapPetGesture)
        
        hintImageView.isUserInteractionEnabled = true
        let hintGesture = UITapGestureRecognizer(target: self, action: #selector(displayChildList))
        hintImageView.addGestureRecognizer(hintGesture)
        
        child_pet_cup_level.layer.masksToBounds = true
        child_pet_cup_level.layer.cornerRadius = child_pet_cup_level.frame.height/2
        
    }
    
    fileprivate func layoutBackView() {
        backView.backgroundColor = .black
        backView.alpha = 0.0
        view.addSubview(backView)
        backView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
    }
    
    @objc func petSelect(_ sender: UIGestureRecognizer) {
        if GUser.share.activeChild?.hasPet == 0 ||  GUser.share.activeChild?.hasPet == nil{
            GUser.share.appStatus = .addPet
            gotoSelectPetVC()
        }
    }
    
    // MARK: -  Update mainVC view
    func updateChildAvatar() {
        let imagePath: String! = activeChildID + ".jpg"
        profileImageView.imagePath = imagePath
        profileImageView.layoutSubviews()
        if helper.settingDisplayed{
            if configurePopup != nil {
                configurePopup.layAvatorImage()
            }
        }
    }
    
    func setUnitLabelText(_ sting: String) {
        unitL.text = sting
    }
    
    func updateViewDataInfo() {
        name.text = GChild.share.getActiveChildName()
    }
    
    fileprivate func hideDrinkWaterView() {
        if helper.drinkBarChartDisplayed {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.backView.alpha = 0.0
                self.waterBarView!.center.y = BASE_FRAME.height+self.helper.barViewheight/2
            }, completion: { (ret:Bool) in
                self.helper.drinkBarChartDisplayed = false})
        }
    }
    
    fileprivate func hideConfigView() {
        if helper.settingDisplayed {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.backView.alpha = 0.0
                if self.configurePopup != nil{
                    self.configurePopup.configView.layer.shadowColor = UIColor.clear.cgColor
                    self.configurePopup!.center.x = BASE_FRAME.width+self.helper.settingWidth
                }
            }, completion: {(ret:Bool) in
                self.helper.settingDisplayed = false
            })
        }
    }
    
    fileprivate func hideAddChildView() {
        if helper.childrenDisplayed {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.backView.alpha = 0.0
                if self.addChildrenView != nil{
                    self.addChildrenView.childrenView.layer.shadowColor = UIColor.clear.cgColor
                    self.addChildrenView!.center.x = -self.helper.childrenWidth/2
                }
            }, completion: {(ret:Bool) in
                self.helper.childrenDisplayed = false
            })
        }
    }
    
    @objc func hideDetailBarChart(_ sender: UIGestureRecognizer) {
        hideDrinkWaterView()
        
        hideConfigView()
    
        hideAddChildView()
    }
    
    @objc func displayChildList() {
        layoutAddChildView()
        
        UIView.animate(withDuration: 0.15, animations: {
            
            self.photoMaskView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.photoMaskView.alpha = 0.8
            }, completion: {(success:Bool) -> Void in
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.photoMaskView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.photoMaskView.alpha = 1.0
                    }, completion: {(success:Bool)->Void in DispatchQueue.main.async(execute: {
                        
                        if self.helper.childrenDisplayed == false {
                            self.addChildrenView.childrenList = GUser.share.childList as NSArray
                            self.addChildrenView.childrenCollectionView.reloadData()
                            self.view.bringSubview(toFront: self.addChildrenView!)
                            
                            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                                self.addChildrenView!.center.x = self.helper.childrenWidth/2
                                self.backView.alpha = 0.2
                                self.addChildrenView.childrenView.layer.shadowColor = UIColor.black.cgColor
                            }, completion: nil)
                            self.helper.childrenDisplayed = true
                        }
                    })
                })
        })
    }
    
    @objc func loadChildren(_ sender: UIGestureRecognizer) {
        displayChildList()
    }
    
    @IBAction func drink_button_click_down(_ sender: Any) {
        viewVolButton.alpha = 0.5
    }
    @IBAction func drink_button_click_out(_ sender: Any) {
        self.viewVolButton.alpha = 1.0
    }
    
    
    @IBAction func ViewDetailBarChart(_ sender: UIButton) {
        loadWaterBarView()
        //Flurry.logEvent("Main_drink_water_btn_click")
        if helper.drinkBarChartDisplayed == false && waterBarView != nil{
            let height = view.bounds.height/2.22
            view.bringSubview(toFront: waterBarView!)
            loadDirnkWaterLog(true)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.waterBarView!.center.y -= height
                self.backView.alpha = 0.1
                }, completion: {(success:Bool) -> Void in
                    self.viewVolButton.alpha = 1.0
                    self.loadDrinkWaterBarView()
                })
            self.helper.drinkBarChartDisplayed = true
        }
    }
    
    func loadDrinkWaterBarView() {
        if waterBarView?.waterShowModel == .week {
            //Flurry.logEvent("Main_drink_water_week_btn_click")
            waterBarView?.loadWeekStyleView()
        }else{
            waterBarView?.loadDayStryleView()
        }
    }
    
    // MARK: - Pet  View
    @IBAction func showPetView(_ sender: Any) {
        //Flurry.logEvent("Main_my_pet_btn_click")
        removeRedSignFromPetButton()
        helper.save_click_pet_button(true)
        let mainSB = UIStoryboard(name: "PetParadise", bundle: nil)
        let upgradeView = mainSB.instantiateViewController(withIdentifier: "PetParadise")
        navigationPushView(upgradeView)
    }
    
    func navigationPushView(_ view: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    // MARK: - Friend List View
    @IBAction func ShowFriends(_ sender: UIButton){
        //Flurry.logEvent("Main_my_friend_btn_click")
        FriendHelper.share.save_click_friend_button_para(true)
        let friendsSB: UIStoryboard = UIStoryboard(name: "FriendsVC", bundle: nil)
        let friendListVC: FriendsListVC = friendsSB.instantiateViewController(withIdentifier: "FriendsListVC") as! FriendsListVC
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    func gotoSelectPetVC() {
        UIView.animate(withDuration: 0.15, animations: {
            self.petImageView.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            self.petImageView.alpha = 0.8
            }, completion: {(success: Bool) -> Void in
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.petImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.petImageView.alpha = 1.0
                    }, completion: {(success: Bool) -> Void in DispatchQueue.main.async(execute: {

                        let sb = UIStoryboard(name: "ChosePet", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "PetSelectionVC")
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    })
                })
        })
    }
    
    // MARK: Check first time to come in
    fileprivate func checkIfFirstTimePaired() {
        let isFristPaired = AppDelegateHelper.share.readIsFirstInstallAndPairedValue()
        if isFristPaired {
            return
        }else{
            //Flurry.logEvent("tutorial_1st_show")
            self.perform(#selector(MainVC.mainViewPersentTurtorialVC), with: self, afterDelay: 3.0)
        }
    }
    
    @objc func mainViewPersentTurtorialVC() {
        AppDelegateHelper.share.saveIsFirstInstallAndPairedValue(true)
        TutorialHelper.share.enterType = .pairMainVcIn
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let upgradeView = mainSB.instantiateViewController(withIdentifier: "tutorial")
        navigationPushView(upgradeView)
    }
    
    func hidenVolumeButton(_ isTrue:Bool) {
        viewVolButton.isHidden = isTrue
        unitL.isHidden = isTrue
    }
    
    // MARK: - Load AddChildView
    fileprivate func layoutAddChildView() {
        if (view.subviews.filter { return $0.isKind(of: AddChildView.self) }.count == 0 ) {
            if addChildrenView == nil {
                addChildrenView = AddChildView()
                addChildrenView.frame = CGRect(x: -helper.childrenWidth, y: 0.0, width: helper.childrenWidth, height: view.bounds.height)
                addChildrenView.container = self
                addChildrenView.delegate = self
                addChildrenView.childrenList  = GUser.share.childList as NSArray
                view.addSubview(addChildrenView)
            }
        }
    }
    
    func checkChildPairSuccess() {
        LoadingView().showLodingInView()
        GCup.share.getChildCupList({ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result{
                    GUser.share.updateCurrentChildInChildList()
                    if self.addChildrenView != nil {
                        self.addChildrenView.childrenList  = GUser.share.childList as NSArray
                        self.addChildrenView.childrenCollectionView.reloadData()
                    }
                    self.checkAddbottleButtonHidden()
                }else{
                    self.gotoonnectBottleToSetSSID()
                }
            }
            
        })
    }
    
    func gotoonnectBottleToSetSSID() {
        GUser.share.appStatus = .bindCup
        let sb = UIStoryboard(name: "PairCup", bundle: nil)
        
        if !PairCupHelper.share.IsConnectValiedWiFi() {
            let stationVC: WifiStationConnectVC = sb.instantiateViewController(withIdentifier: "WifiStationConnect") as! WifiStationConnectVC
            navigationController?.navigationBar.isHidden = false
            navigationController!.pushViewController(stationVC, animated: true)
        } else {
            let setupVC: SSIDSetupVC = sb.instantiateViewController(withIdentifier: "SSIDSetupVC") as! SSIDSetupVC
            navigationController?.navigationBar.isHidden = false
            navigationController!.pushViewController(setupVC, animated: true)
        }
    }
    
    func didSelectoCellAction(_ selectType: CellSelectType, selectIndex: Int) {
        switch selectType {
        case .changeChild:
            if helper.childrenDisplayed{
                let width = view.bounds.width/1.44
                backView.alpha = 0.0
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.addChildrenView!.center.x -= width
                    }, completion: {(ret: Bool) in
                        self.helper.childrenDisplayed = false
                })
            }
            updateActiveChild(selectIndex)
        case .addChild:
            MianVCHepler.share.successHander = .addChildHander
            checkoutParentLockView()
        }
    }
    
    func gotoAddChildView()  {
        UserDefaults.standard.set(NSNumber(value: false as Bool), forKey: enterSSIDNotSignup)
        UserDefaults.standard.synchronize()
        GUser.share.appStatus = .addChild
        GUser.share.isChildCreated = false
        GUser.share.workingChild = nil
        goto(vcName: "NameVC", boardName: "Register")
    }
    
    // MARK: - Change Child
    func updateActiveChild(_ index: Int) {
        GUser.share.changeAvtiveChild(index)
        getChildPhotoURL()
        clearDrinkWaterLog()
        loadDirnkWaterLog(false)
        updateHabites()
        updateActiveChildInfo()
        checkChildPetSwitch()
        check_out_add_friend_message_show_red_sign()
        checkout_pet_stort_img_status()
        get_child_pet_cup_level()
        BaseHelper.base_share.cancel_paly_view()
    }
   
    // MARK: - Http Request
    @objc func app2Forground(_ notification: Notification) {
        getAPIVersion()
        updateHabites()
        loadDirnkWaterLog(true)
        updateActiveChildInfo()
        checkChildPetSwitch()
        helper.addBottleButtonIsAnimation = false
        addBottleShowSyncRotation()
    }
    
    func updateActiveChildInfo(){
        if !Common.checkInternetConnection(){
            updateViewDataInfo()
            checkAddbottleButtonHidden()
            changeChildLoadPet()
        }
        GChild.share.updateActiveChildInfo({ result in
            self.changeChildLoadPet()
            DispatchQueue.main.async {
                self.updateViewDataInfo()
                self.checkAddbottleButtonHidden()
            }
        })
    }
    
    func changeChildLoadPet()  {
        GPet.share.chosePetSucced = false
        helper.showEggOrPet = .defaultNoMaskView
        DispatchQueue.main.async {
            self.changePetScrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        displayCurrentPet()
    }
    
    // MARK: - Load BHMaskView
    func loadBHMaskView(_ point: CGPoint) {
        var maskView:BHMaskView
        let views = view.subviews.filter( {$0.isKind(of: BHMaskView.self)} )
        if views.count > 0 {
            maskView = views[0] as! BHMaskView
        }else {
            maskView = BHMaskView()
            maskView.delegate = self
            maskView.frame = view.frame
            view.addSubview(maskView)
        }
        
        maskView.alpha = 0.0
        maskView.setMaskLayer(point, tag:0)
        maskView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            maskView.alpha = 1.0
        }) 
    }
    
    // MARK: - BHMaskView Delegate
    func tapOnAddBottleButton() {
        if GPet.share.showPetStatus == .sync{
            showSyncView(addBottleButton)
        }else{
            checkChildPairSuccess()
        }
    }
    
    // MARK: - Load ConfigureView
    fileprivate func loadConfigureView() {
        if configurePopup != nil {
            configurePopup.viewWillAppearEveryOnce()
            return
        }
        configurePopup = SettingPopupV()
        configurePopup.frame = CGRect(x: SCREEN_WIDTH, y: 0.0, width: helper.settingWidth, height: SCREEN_HEIGHT)
        configurePopup.container = self
        view.addSubview(configurePopup)
        configurePopup.viewWillAppearEveryOnce()
        view.bringSubview(toFront: configurePopup!)
    }
    
    func checkoutParentLockView() {
//        if !Common.checkPreferredLanguagesIsEn(){
//            lockSuccessHandel()
//            return
//        }
        lock.showLock()
        
        weak var WeakSelf = self
        lock.locked_done(block: {
            WeakSelf?.lockSuccessHandle()
        })
    }
    
    func lockSuccessHandle() {
        if helper.successHander == .cupinfoHander{
            goto(vcName: "cupCenter", boardName: "Settings")
        }else if helper.successHander == .settingHander{
            gotoSettingViews("SettingsVC")
        }else if helper.successHander == .childInfoHander{
            gotoSettingViews("AlterChild")
        }else if helper.successHander == .helpshiftHander{
            showHelpshiftContanier()
        }else if helper.successHander == .addChildHander{
            gotoAddChildView()
        }else if helper.successHander == .helpshiftBoxHander{
            showInbox()
        }
    }
    
    func showConfigView(){
        loadConfigureView()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.backView.alpha = 0.2
            self.configurePopup!.center.x = BASE_FRAME.width - self.helper.settingWidth/2
            self.configurePopup.configView.layer.shadowColor = UIColor.black.cgColor
        }, completion: { bool in
            if bool{
                self.helper.settingDisplayed = true
            }
        })
    }
    
    @IBAction func ConfigurePopup(_ sender: UIButton) {
        helper.successHander = .settingHander
        showConfigView()
    }
    
    func loadHelpShiftCount() {
        if configurePopup != nil {
            configurePopup.load_helpshift_message_count()
        }
    }
    
    // MARK: - Load WaterBarView
    func loadWaterBarView() {
        if (waterBarView != nil) {
            return
        }
        waterBarView = WaterBarChart(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: helper.barViewheight))
        waterBarView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        waterBarView?.intakeHourInDay = GChild.share.drinkWaterHourArray
        waterBarView?.intakeDayInWeek = GChild.share.drinkWaterDayArray
        view.addSubview(waterBarView!)
    }
    
    func clearDrinkWaterLog() {
        GChild.share.drinkWaterHourArray = [0,0,0,0,0,0,0]
        GChild.share.drinkWaterDayArray = [0,0,0,0,0,0,0]
        if waterBarView != nil {
            waterBarView?.intakeHourInDay = GChild.share.drinkWaterHourArray
            waterBarView?.intakeDayInWeek = GChild.share.drinkWaterDayArray
            loadDrinkWaterBarView()
        }
    }
    
    func loadDirnkWaterLog(_ ischeckoutTime : Bool) {
        if ischeckoutTime{
            let eclapsedTime = Date().timeIntervalSince(GChild.share.lastDrinkUpdate)
            if eclapsedTime < 5 {
                return
            }
        }
        GChild.share.lastDrinkUpdate = Date()
        dayDrinkWaterLog()
        weekDrinkWaterLog()
    }
    
    func loadWaterBgImageView(_ per:Float?) {
        if waterWave == nil {
            waterWave = WaterLayerView(frame: ScreenRect)
            view.insertSubview(waterWave!, aboveSubview: backgroundView)
        }
        waterWave!.setnewPercent(CGFloat(GChild.share.handleWaterPer(per)))
    }
    
    // MARK: - Show upgrade view Deleagte
    @objc func showMainUpgradeView() {
        if MainUpgrade.shareInstance.petGradeStatus == .done{
            changeChildLoadPet()
            hideDetailBarChart(UIGestureRecognizer())
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if MainUpgrade.shareInstance.showView{
                let mainSB = UIStoryboard(name: "Main", bundle: nil)
                let upgradeView = mainSB.instantiateViewController(withIdentifier: "upgrade")
                self.navigationPushView(upgradeView)
            }
        }
    }

    // MARK: - BHAletView Deleagte
    func rightButtonDelegateAction() {
        let url = URL(string: apple_store_url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: ["":""], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    
    func showUpdate(){
        let alertView = BHAlertView(frame: view.frame)
        alertView.delegate = self
        alertView.initAlertContent(GVersion.share.msgTitle, message: GVersion.share.detail, leftBtnTitle: Localizaed("Not now"), rightBtnTitle: Localizaed("Update"))
        alertView.presentBHAlertView()
    }
    
    func showForceUpdate() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.delegate = self
        alertView.initAlertContent(GVersion.share.msgTitle, message: GVersion.share.detail, leftBtnTitle: "", rightBtnTitle: Localizaed("Update"))
        alertView.presentBHAlertView()
    }
    
    //goto cupcenter
    func connectBottleToSetSSID(_ index: Int) {
        helper.successHander = .cupinfoHander
        checkoutParentLockView()
        updateActiveChild(index)
    }
    
    func gotoSettingViews(_ viewName: String) {
        let settingSB = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = settingSB.instantiateViewController(withIdentifier: viewName)
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func showHelpshiftContanier()  {
        HelpshiftSupport.showFAQs(self, with: GUser.share.setHelperShfitMetadata())
    }   
}
