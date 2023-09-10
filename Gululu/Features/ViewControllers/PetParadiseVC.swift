//
//  PetParadiseVC.swift
//  Gululu
//
//  Created by Baker on 17/2/13.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import DOUAudioStreamer
////import Flurry_iOS_SDK


class PetParadiseVC: BaseViewController ,UIScrollViewDelegate, BHAlertViewDelegate{

    @IBOutlet weak var PetScrollView: UIScrollView!
    @IBOutlet weak var change_pet_switch: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var banner: UILabel!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var pet_story_play_sign: FLAnimatedImageView!
    @IBOutlet weak var pet_story_play_sign_bg: FLAnimatedImageView!
    
    
    let petParadiseHelper =  GPetParadise.share
    let delegateHelper = AppDelegateHelper.share
    var petSelectView : UIView?
    var imageView : UIImageView?
    var petNoRepeatList : [Pets]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPetScollerView()
        initLayerImage()
        checkAddLayerImage()
        setBannerStyle()
        
        pet_story_play_sign.isUserInteractionEnabled = true
        let tapGesture_1 = UITapGestureRecognizer(target: self, action: #selector(petdise_goto_pet_story_view))
        pet_story_play_sign.addGestureRecognizer(tapGesture_1)
        change_pet_switch.setTitle(Localizaed("Switch \r Pet"), for: .normal)
    }
    
    func checkout_pet_stort_img_status()  {
        if PetStoryHelper.share.can_show_pet_story_enter(){
            pet_story_play_sign.isHidden = false
            pet_story_play_sign_bg.isHidden = false
            if PetStoryHelper.share.streamer?.status == DOUAudioStreamerStatus.playing{
                let petFile = "pet_story_play"
                let URLPet = Bundle.main.url(forResource: petFile, withExtension: "gif")
                let dataPet = try? Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
                pet_story_play_sign.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
            }else{
                pet_story_play_sign.image = UIImage(named: "pet_story_play_btn")
            }
        }else{
            pet_story_play_sign.isHidden = true
            pet_story_play_sign_bg.isHidden = true
        }
    }
    
    @objc func petdise_goto_pet_story_view() {
        //Flurry.logEvent("paradise_pet_story_btn_click")
        if  BaseHelper.base_share.pet_story_view == nil{
            let mainSB = UIStoryboard(name: "PetParadise", bundle: nil)
            BaseHelper.base_share.pet_story_view = mainSB.instantiateViewController(withIdentifier: "petStory") as? PetStoryVC
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(BaseHelper.base_share.pet_story_view!, animated: false)
    }
    
    func setPetScollerView() {
        PetScrollView.contentSize = CGSize(width: petParadiseHelper.widthProtion, height: SCREEN_WIDTH)
        PetScrollView.setContentOffset(CGPoint(x: (petParadiseHelper.widthProtion-SCREEN_HEIGHT)/2, y: 0), animated: false)
        PetScrollView.showsHorizontalScrollIndicator = false
        PetScrollView.showsVerticalScrollIndicator = false
        PetScrollView.bounces = false
        PetScrollView.delegate = self
        
        if #available(iOS 11.0, *){
            PetScrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func setBannerStyle() {
        banner.layer.masksToBounds = true
        banner.layer.borderColor = UIColor.white.cgColor
        banner.layer.borderWidth = 3.0
        banner.layer.cornerRadius = 20.0
        banner.backgroundColor = RGB_COLOR(116, g: 101, b: 180, alpha: 1)
    }
    
    @IBAction func back(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        hideNavigation()
        checkout_pet_stort_img_status()
        change_pet_switch.isHidden = petParadiseHelper.checkout_change_pet_switch_hidden()
    }
    
    func checkAddLayerImage() {
        let loadView = LoadingView()
        loadView.showLodingInView()
        loadView.lodingImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        if !checkInternetConnection(){
            LoadingView().stopAnimation()
            return
        }
        petParadiseHelper.getPetPlants({result in
            DispatchQueue.main.async {
                self.addLayerImage()
                self.updateAllPetList()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLayerImage() {
        if isValidArray(petParadiseHelper.plantLayerNumArray) {
            imageView?.image = UIImage(named: "all_plant_layer")
            imageView?.tag = petParadiseHelper.bgImageTag
        }else{
            imageView?.image = UIImage(named: "no_plant_layer")
            imageView?.tag = petParadiseHelper.bgImageTag
        }
    }
    
    func initLayerImage() {
        imageView?.isUserInteractionEnabled = true
        imageView = createImage(imageName: "no_plant_layer", imageTag: petParadiseHelper.bgImageTag)
        imageView?.tag = petParadiseHelper.bgImageTag
        PetScrollView.addSubview(imageView!)
    }
    
    func createImage(imageName:String,imageTag:Int) -> UIImageView{
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: petParadiseHelper.widthProtion, height: SCREEN_WIDTH))
        imageView.image = UIImage(named: imageName)!
        imageView.tag = imageTag
        return imageView
    }
    
    func updateAllPetList() {
        hiddenBannerSync()
        GPet.share.displayCurrentPet {
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if GPet.share.showPetStatus == .sync{
                    self.addPetInLayer(1)
                    self.showBannerSync()
                }else{
                   self.addPetInLayer(0)
                }
            }
        }
    }
    
    func hiddenBannerSync() {
        self.banner.isHidden = true
    }
    
    func showBannerSync() {
        self.banner.isHidden = false
        var syncStr = Localizaed("Please put your Gululu on the charging dock, and wait for the data sync to finish.")
        let width = Common.getLabWidth(labelStr: syncStr, font: banner.font, height: 25)
        if width > banner.frame.width{
            syncStr = Localizaed("Please put your Gululu on the charging dock, \rand wait for the data sync to finish.")
            bannerHeight.constant = 80
        }else{
            bannerHeight.constant = 60
        }
        self.banner.text = syncStr

        let att1 : NSAttributedString = NSAttributedString(string: banner.text!, attributes: [NSAttributedStringKey.font: banner.font, NSAttributedStringKey.baselineOffset:-4])
        banner.attributedText = att1
        banner.baselineAdjustment = .none
    }
    
    func showWhitchBigPet(_ tag:Int) -> Pets?{
        if tag == 0{
            return GPet.share.getActivePetInPetList()
        }else {
            return GPet.share.getNextPetInPetList()
        }
    }
    
    func addPetInLayer(_ tag:Int) {
        GPet.share.readPetFromeLocal()
        petNoRepeatList = GPet.share.getNoRepeatPets()
        guard petNoRepeatList?.count != 0 else {
            return
        }
        if petNoRepeatList?.count == 1{
            change_pet_switch.isHidden = true
        }
        let bigPet = showWhitchBigPet(tag)
        guard bigPet?.petName != nil else {
            return
        }
        if petParadiseHelper.checkout_add_egg(GUserConfigUtil.share.checkout_add_next_pet_feature()){
            let eggPet : Pets? = createObject(Pets.self) as Pets?
            eggPet?.petName = GPet.share.Egg
            petNoRepeatList?.append(eggPet!)
        }
        
        let imageWidth = imageView?.frame.size.width
        guard imageWidth != nil else {
            return
        }
        for i in 1...(petNoRepeatList?.count)!{
            let pet = petNoRepeatList?[i-1]
            let count = petNoRepeatList?.count
            let x1 = imageWidth!/2 - petParadiseHelper.width/2 - (petParadiseHelper.twoPetImageWidth + petParadiseHelper.width) * CGFloat(count! - 1)/2
            let x2 = (CGFloat(i) - 1)*(petParadiseHelper.twoPetImageWidth + petParadiseHelper.width)
            let x =  x1 + x2
            if pet?.petName == GPet.share.Egg{
                let rect = CGRect(x: x, y: 0 , width: petParadiseHelper.width-20, height: petParadiseHelper.height)
                addEggButtonInImageView(rect: rect)
            }else{
                let petImageView : FLAnimatedImageView
                if pet?.petNum != bigPet?.petNum {
                    let rect = CGRect(x: x, y: 0 , width: petParadiseHelper.width, height: petParadiseHelper.height)
                    petImageView = FLAnimatedImageView(frame: rect)
                    petImageView.alpha = 0.8
                }else{
                    let rect = CGRect(x: x, y: 0 , width: petParadiseHelper.width, height: petParadiseHelper.height)
                    petImageView = FLAnimatedImageView(frame: rect)
                }
                petImageView.tag = i+petParadiseHelper.petImageTag
                petImageView.center.y = (imageView?.center.y)!
                let bundle = Bundle.main
                let petFileName = GPet.share.getPetImageName(pet?.petName)
                let URLPet = bundle.url(forResource: petFileName, withExtension: "gif")
                let dataPet = try! Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
                petImageView.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
                addGestureInPetImageView(petImageView)
                petImageView.contentMode = .scaleAspectFit
                petImageView.isUserInteractionEnabled = true
                PetScrollView.addSubview(petImageView)
                create_head_sign_tips(petImageView, tag: petImageView.tag)
            }
        }
        animationBigPet(bigPet)
    }
    
    func animationBigPet(_ bigPet : Pets?) {
        for i in 1...(petNoRepeatList?.count)!{
            let pet = petNoRepeatList?[i-1]
            if pet?.petNum == bigPet?.petNum {
                let tapView : UIView = view.viewWithTag(i + petParadiseHelper.petImageTag)!
                tapView.transform = tapView.transform.scaledBy(x: 1.5, y: 1.5)
            }
        }
    }
    
    func create_Head_sign(_ petImageView:FLAnimatedImageView, tag:Int?) {
        if tag == nil {
            return
        }
        let head_image_view = UIImageView()
        head_image_view.frame = CGRect(x: 0 , y: 0, width: petParadiseHelper.headImageWidth, height: petParadiseHelper.headImageWidth)
        head_image_view.tag = tag!+petParadiseHelper.change_model_currnet_tag
        head_image_view.center.y = petImageView.center.y - CGFloat(20)
        head_image_view.center.x = petImageView.center.x
        head_image_view.image = UIImage(named: "paradise_select_pet_indicator")
        PetScrollView.addSubview(head_image_view)
    }
    
    func create_head_sign_tips(_ petImageView:FLAnimatedImageView, tag:Int?) {
        if tag == nil {
            return
        }
        let pet = petNoRepeatList?[tag!-petParadiseHelper.petImageTag-1]
        if GPet.share.checkPetIsActive(pet){
            add_avtive_head_sign(petImageView, tag:tag)
        }
        if GPet.share.checkPetIsNext(pet){
            add_next_head_sign(petImageView, tag:tag)
        }
    }
    
    func add_avtive_head_sign(_ petImageView:FLAnimatedImageView, tag:Int?) {
        let head_image_view = UIImageView()
        head_image_view.tag = tag!+petParadiseHelper.active_pet_tag
        head_image_view.image = UIImage(named: "paradise_active_tips")
        PetScrollView.addSubview(head_image_view)
        
        head_image_view.snp.makeConstraints { (containView) in
            containView.centerX.equalTo(petImageView)
            containView.centerY.equalTo(view).offset(-petParadiseHelper.ACWidth/2-10)
            containView.size.equalTo(CGSize(width: petParadiseHelper.headSignWigth, height: petParadiseHelper.headSignWigth))
        }
        animaiton_avtive_tips(head_image_view)
    }
    
    func animaiton_avtive_tips(_ head_image_view:UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .repeat, animations: {
            head_image_view.frame.origin.y = head_image_view.frame.origin.y + 3
        }) { (finish) in
            head_image_view.frame.origin.y = head_image_view.frame.origin.y - 3
        }
    }
    
    func add_next_head_sign(_ petImageView:FLAnimatedImageView, tag:Int?) {
        let head_image_view = UIImageView()
        head_image_view.tag = tag!+petParadiseHelper.active_pet_tag
        head_image_view.image = UIImage(named: "turnover")
        PetScrollView.addSubview(head_image_view)

        head_image_view.snp.makeConstraints { (containView) in
            containView.centerX.equalTo(petImageView)
            containView.centerY.equalTo(view).offset(-petParadiseHelper.ACWidth/2-10)
            containView.size.equalTo(CGSize(width: petParadiseHelper.headSignWigth, height: petParadiseHelper.headSignWigth))
        }
        add_next_pet_animation(head_image_view)
    }
    
    func add_next_pet_animation(_ head_image_view:UIImageView) {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 2
        head_image_view.layer.add(anim, forKey: nil)
    }
    
    func addGestureInPetImageView(_ petImageView:FLAnimatedImageView) {
        let tapGes = UITapGestureRecognizer()
        tapGes.numberOfTapsRequired = 1
        tapGes.addTarget(self, action: #selector(petTap))
        petImageView.addGestureRecognizer(tapGes)
    }
    
    @objc func petTap(sender:UIGestureRecognizer) {
        //Flurry.logEvent("Pet_view_click_pet")
        let tapView = sender.view
        if tapView?.frame.width < petParadiseHelper.middleWidth{
            UIView.animate(withDuration: 0.2, animations: {
                tapView?.alpha = 1.0
                tapView?.transform = (tapView?.transform.scaledBy(x: 1.5, y: 1.5))!
            }, completion: { (handle) in
                if handle{
                    if self.petParadiseHelper.switch_pet_model{
                        self.createConfirmButton(tapView as! FLAnimatedImageView, tag: tapView?.tag)
                        self.create_Head_sign(tapView as! FLAnimatedImageView, tag: (tapView?.tag)!)
                    }
                }
            })
        }

        for i in 1...(petNoRepeatList?.count)!{
            let petView = view.viewWithTag(i+100)
            if petView?.tag != tapView?.tag && petView?.frame.width > petParadiseHelper.middleWidth{
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    petView?.alpha = 0.8
                    petView?.transform = (petView?.transform.scaledBy(x: 2/3, y: 2/3))!
                }, completion: { (handle) in
                    if handle{
                        if self.petParadiseHelper.switch_pet_model{
                            self.remove_button((petView?.tag)!+100)
                            self.remove_head_image((petView?.tag)!+200)
                        }
                    }
                })
            }
        }
    }
    
    func createConfirmButton(_ petImageView:FLAnimatedImageView, tag:Int?) {
        if tag == nil{
            return
        }
        var switchButton : UIButton? = self.view.viewWithTag(tag! + 100) as? UIButton
        if switchButton != nil{
            switchButton?.isHidden = false
            return
        }
        switchButton = UIButton()
        let pet = petNoRepeatList?[tag!-petParadiseHelper.petImageTag-1]
        if petParadiseHelper.checkout_confirm_button_hidden(pet){
            return
        }
        let origin = petImageView.frame.origin
        let size = petImageView.frame.size
        let buttonTitle = Localizaed("Choose")
        switchButton?.tag = tag!+petParadiseHelper.petImageTag
        switchButton?.frame = CGRect(x: origin.x + 40, y: origin.y+size.height+20, width: 80, height: 70)
        switchButton?.addTarget(self, action: #selector(changePet), for: .touchUpInside)
        switchButton?.setTitle(buttonTitle, for: .normal)
        switchButton?.setTitleColor(.white, for: .normal)
        switchButton?.setBackgroundImage(UIImage(named: "green_button"), for: .normal)
        PetScrollView.addSubview(switchButton!)
    }
    
    func remove_button(_ tag:Int) {
        let button = view.viewWithTag(tag)
        button?.removeFromSuperview()
    }
    
    func remove_head_image(_ tag:Int) {
        let head_image = view.viewWithTag(tag)
        head_image?.removeFromSuperview()
    }
    
    func showChangePetAlter() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.backView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        alertView.initAlertContent("ATTENTION", message: Localizaed("Did your to change this pet"), leftBtnTitle: CANCEL, rightBtnTitle:CONTINUE)
        alertView.presentBHAlertView()
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    
    func rightButtonDelegateAction() {
        //
       
    }
    
    func showSitchPetFailed() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.backView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        alertView.initAlertContent("", message: Localizaed("Change pet failed, Pleast try again later"), leftBtnTitle: CANCEL, rightBtnTitle:CONTINUE)
        alertView.presentBHAlertView()
    }
    
    func showWaitSync() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.backView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        alertView.initAlertContent("", message:  Localizaed("Please put your Gululu on the charging dock, and wait for the data sync to finish."), leftBtnTitle: "", rightBtnTitle:DONE)
        alertView.presentBHAlertView()
    }
    
    func addEggButtonInImageView(rect:CGRect) {
        let eggButton = UIButton(frame:rect)
        eggButton.center.y = (imageView?.center.y)! + FIT_SCREEN_WIDTH(40)
        eggButton.tag = petParadiseHelper.egg_button_tag
        eggButton.addTarget(self, action: #selector(addEggButtonAction), for: .touchUpInside)
        eggButton.setBackgroundImage(UIImage(named: "paradise_add_pet_egg"), for: .normal)
        PetScrollView?.addSubview(eggButton)
        setTimerToEggAnimation(eggButton)
    }
    
    func setTimerToEggAnimation(_ egg_image_view:UIButton) {
        petParadiseHelper.timer = DispatchSource.makeTimerSource(queue: .main)
        petParadiseHelper.timer?.schedule(deadline: .now(), repeating: .seconds(5))
        petParadiseHelper.timer?.setEventHandler {
            self.animation_egg_shake(egg_image_view)
        }
        petParadiseHelper.timer?.resume()
    }
    
    func animation_egg_shake(_ egg_image_view:UIButton) {
        let myAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
        myAnimation.isRemovedOnCompletion = false
        let left: CGFloat = CGFloat(-Double.pi/2) * 0.1
        let right: CGFloat = CGFloat(Double.pi/2) * 0.1
        
        myAnimation.keyPath = "position"
        myAnimation.keyPath = "transform.rotation"
        
        myAnimation.values = [(left),(right),(left)]
        myAnimation.duration = 0.2
        myAnimation.repeatCount = 8
        egg_image_view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        egg_image_view.layer.add(myAnimation, forKey: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    @objc func addEggButtonAction() {
        //Flurry.logEvent("Pet_view_egg_click")
        let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
        if childHasBotleState == .both{
            let loadView = LoadingView()
            loadView.showLodingInView()
            loadView.lodingImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            GPet.share.getNextPetsFromRemote { (result) in
                DispatchQueue.main.async {
                    loadView.stopAnimation()
                    if GPet.share.can_add_pet{
                        self.showSelectPetView()
                    }else{
                        self.showAddPetLimitLevel()
                    }
                }
            }
        }else{
            showPairCupTips()
        }
    }
    
    func showAddPetLimitLevel() {
        var limit_level_view : UIView? = self.view.viewWithTag(600)
        if limit_level_view != nil {
            if limit_level_view?.alpha == 0{
                show_limit_view_animation(limit_level_view!)
                return
            }
            return
        }
        let egg_button : UIView = self.view.viewWithTag(499)!
        let size = egg_button.frame.size
        let origin  = egg_button.frame.origin
        limit_level_view = UIView(frame: CGRect(x: origin.x + size.width - 20, y: origin.y - 50, width: 100, height: 50))
        limit_level_view?.backgroundColor = .clear
        limit_level_view?.alpha = 0
        limit_level_view?.tag = petParadiseHelper.limit_level_view_tag
        PetScrollView.addSubview(limit_level_view!)
        
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        bgImageView.image = UIImage(named: "paradise_tips")
        limit_level_view?.addSubview(bgImageView)
        
        let lvImageView = UIImageView(frame: CGRect(x: 10, y: 12, width: 23, height: 15))
        lvImageView.image = UIImage(named: "paradise_level")
        limit_level_view?.addSubview(lvImageView)
        
        let label = UILabel(frame: CGRect(x: 35, y: 0, width: 60, height: 38))
        label.text = String(format:"%@%@", GPet.share.pet_notify_level, Localizaed("Unlock"))
        label.textColor = .white
        label.font = UIFont(name: BASEFONT, size: 18)
        limit_level_view?.addSubview(label)
        
        show_limit_view_animation(limit_level_view!)
    }
    
    func show_limit_view_animation(_ limit_level_view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            limit_level_view.alpha = 1.0
        }){ (finish) in
            if finish{
                self.hiden_limit_level_view_animation(limit_level_view)
            }
        }
    }
    
    func showPairCupTips(){
        var limit_level_view : UIView? = self.view.viewWithTag(petParadiseHelper.limit_show_no_pair_tag)
        if limit_level_view != nil {
            if limit_level_view?.alpha == 0{
                show_limit_view_animation(limit_level_view!)
                return
            }
            return
        }
        let egg_button : UIView = self.view.viewWithTag(499)!
        let size = egg_button.frame.size
        let origin  = egg_button.frame.origin
        limit_level_view = UIView(frame: CGRect(x: origin.x + size.width - 20, y: origin.y - 50, width: 110, height: 50))
        limit_level_view?.backgroundColor = .clear
        limit_level_view?.alpha = 0
        limit_level_view?.tag = petParadiseHelper.limit_show_no_pair_tag
        PetScrollView.addSubview(limit_level_view!)
        
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
        bgImageView.image = UIImage(named: "paradise_tips")
        limit_level_view?.addSubview(bgImageView)
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 110, height: 38))
        label.text = Localizaed("Pair cup, Please!")
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: BASEFONT, size: 14)
        limit_level_view?.addSubview(label)
        
        show_limit_view_animation(limit_level_view!)
    }
    
    func hiden_limit_level_view_animation(_ limit_level_view:UIView){
        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: {
            limit_level_view.alpha = 0.0
        }) {_ in}
    }
    
    @IBAction func switch_pet_model(_ sender: Any) {
        //Flurry.logEvent("Pet_view_change_pet_btn_click")
        if petParadiseHelper.switch_pet_model{
            set_switch_pet_model_false()
        }else{
            add_chose_sign()
            petParadiseHelper.switch_pet_model = true
            backButton.isHidden = true
            pet_story_play_sign.isHidden = true
            pet_story_play_sign_bg.isHidden = true
            change_pet_switch.setTitle(Localizaed("Cancel"), for: .normal)
        }
    }
    
    func set_switch_pet_model_false() {
        petParadiseHelper.switch_pet_model = false
        backButton.isHidden = false
        pet_story_play_sign.isHidden = false
        pet_story_play_sign_bg.isHidden = false
        change_pet_switch.setTitle(Localizaed("Switch \r Pet"), for: .normal)
        remove_chose_sign()
    }
    
    func add_chose_sign() {
        for petImageView : UIView in PetScrollView.subviews {
            if petImageView.tag > 100 && petImageView.tag < 200 {
                if petImageView.frame.width > petParadiseHelper.middleWidth{
                    createConfirmButton(petImageView as! FLAnimatedImageView, tag: petImageView.tag)
                    create_Head_sign(petImageView as! FLAnimatedImageView, tag: petImageView.tag)
                }
            }
            if petImageView.tag > 700 && petImageView.tag < 900{
                petImageView.isHidden = true
            }
            if petImageView.tag == petParadiseHelper.egg_button_tag{
                petImageView.isHidden = true
            }
        }
    }
    
    func remove_chose_sign() {
        for sign_view : UIView in PetScrollView.subviews {
            if sign_view.tag > 200 && sign_view.tag < 400 {
                sign_view.removeFromSuperview()
            }
            if sign_view.tag > 700 && sign_view.tag < 900{
                sign_view.isHidden = false
            }
            if sign_view.tag == petParadiseHelper.egg_button_tag{
                sign_view.isHidden = false
            }
        }
    }

    @objc func changePet(sender:UIButton) {
        //Flurry.logEvent("Pet_view_change_click")
        let pet = petNoRepeatList?[sender.tag-201]
       
        if GPet.share.checkPetIsNext(pet){
            showWaitSync()
            return
        }
        let loadView = LoadingView()
        loadView.showLodingInView()
        loadView.lodingImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        GPet.share.change_pet((pet?.petName!)!, { result in
            DispatchQueue.main.async {
                loadView.stopAnimation()
                if result == 0{
                    pet?.petStatus = GPet.share.next
                    saveContext()
                    GPet.share.showPetStatus = .sync
                    self.resetHadlePet()
                    self.set_switch_pet_model_false()
                }else if result == 1{
                    self.showCannotSupportDonny()
                }else{
                    self.addAnotherFailed()
                }
            }
        })
    }
    
    func resetHadlePet() {
        for view : UIView in PetScrollView.subviews {
            if view.tag > 100 && view.tag < 500 {
                view.removeFromSuperview()
            }
        }
        updateAllPetList()
    }
    
}


