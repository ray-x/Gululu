//
//  MianPet.swift
//  Gululu
//
//  Created by Baker on 16/8/29.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import Foundation

extension MainVC{
    
    func loadNoPet() {
        hidenVolumeButton(true)
        choosePetTipLabel.isHidden = false
        changePetScrollerView.isHidden = true
        petImageView.isHidden = false
        choosePetTipLabel.text = String(format: Localizaed("Let %@\rchoose a new pet!"),GChild.share.getActiveChildName())
        petImageView.image = UIImage(named: "egg")
    }
    
    func loadActivePet() {
        hidenVolumeButton(false)
        choosePetTipLabel.isHidden = true
        changePetScrollerView.isHidden = true
        petImageView.isHidden = false
        loadPetImage()
    }
    
    func loadPetImage() {
        guard GPet.share.showPet?.petName != nil else {
            return
        }
        let petFile = GPet.share.getPetImageName(GPet.share.showPet?.petName)
        let URLPet = Bundle.main.url(forResource: petFile, withExtension: "gif")
        let dataPet = try? Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
        petImageView.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
        petImageView.contentMode = .scaleAspectFit
        petImageView.isHidden = false
        let eclapsedTime = Date().timeIntervalSince(GChild.share.lastDrinkUpdate as Date)
        if eclapsedTime >= 5 {
            dayDrinkWaterLog()
        }
    }
    
    func loadChangePet() {
        helper.petModel = .changePet
        loadPetImage()
        if GPet.share.chosePetSucced {
            petImageView.isHidden = false
            changePetScrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            changePetScrollerView.isHidden = true
            hidenVolumeButton(true)
            choosePetTipLabel.isHidden = true
            return
        }
        loadVCMainViewChangePet(false)
        layoutBootPageVC()
    }
    
    func loadSynPetScoolView() {
        helper.petModel = .syncPet
        loadPetImage()
        loadVCMainViewChangePet(true)
    }
    
    func loadNewSynPetRotationImageView() {
        loadPetImage()
        addBottleShowSyncRotation()
    }
    
    func addBottleShowSyncRotation() {
        addBottleButton.isHidden = false
        addBottleButton.setImage(UIImage(named: "turnover"), for: .normal)
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 2
        if helper.addBottleButtonIsAnimation {
            return
        }
        helper.addBottleButtonIsAnimation = true
        addBottleButton.layer.add(anim, forKey: nil)
    }
    
    func loadSayGoodByeToOldPet() {
        changePetScrollerView.isHidden = true
        loadPetImage()
        showFinishChangePet()
    }
    
    //MARK : - load ChangePetScrollerView
    func loadVCMainViewChangePet(_ isEggOrSyn : Bool) {
        
        petImageView.isHidden = true
        changePetScrollerView.isHidden = false
        loadChangePetScrolleView(isEggOrSyn)
        
        if helper.showEggOrPet == .egg{
            hidenVolumeButton(true)
            choosePetTipLabel.isHidden = false
            changeScrollerViewDidSetView()

        }else  if helper.showEggOrPet == .pet{
            hidenVolumeButton(false)
            choosePetTipLabel.isHidden = true
        }else{
            hidenVolumeButton(false)
            choosePetTipLabel.isHidden = true
        }
    }
    
    func loadChangePetScrolleView(_ isEggOrSyn : Bool) {
        if helper.showEggOrPet == .defaultNoMaskView {
            helper.showEggOrPet = .pet
        }
        loadChangePetScrollerView()
        addPetImageInScrollerView()
        if isEggOrSyn {
            addSynPetInScrollerView()
        }else{
            addChangePetInScrollerView()
        }
        changePetScrollerView.scrollsToTop = true
        view.insertSubview(changePetScrollerView, belowSubview: backView)
    }
    
    func loadChangePetScrollerView(){
        changePetScrollerView.frame = CGRect(x: 0, y: petImageView.frame.origin.y, width: SCREEN_WIDTH, height: petImageView.frame.size.height)
        changePetScrollerView.backgroundColor = .clear
        changePetScrollerView.contentSize = CGSize(width: SCREEN_WIDTH*2, height: petImageView.frame.size.height)
        changePetScrollerView.bounces = false
        changePetScrollerView.showsHorizontalScrollIndicator = false
        changePetScrollerView.delegate = self
        petImageView.center = changePetScrollerView.center
    }
    
    func addPetImageInScrollerView() {
        var petImage : FLAnimatedImageView?
        petImage = changePetScrollerView.viewWithTag(main_change_pet_tag) as? FLAnimatedImageView
        if petImage == nil {
            petImage = FLAnimatedImageView()
            petImage?.contentMode = .scaleAspectFit
            petImage!.frame = CGRect(x: SCREEN_WIDTH/4, y: 0, width: petImageView.frame.size.width, height: petImageView.frame.size.height)
            petImage!.center.x = view.center.x
            petImage!.tag = main_change_pet_tag
            petImage!.animatedImage = petImageView.animatedImage
            changePetScrollerView.addSubview(petImage!)
        }else{
            petImage!.animatedImage = petImageView.animatedImage
        }
    }
    
    func addChangePetInScrollerView() {
        var eggImage : UIButton?
        var onlyEggImage : UIButton?
        eggImage = changePetScrollerView.viewWithTag(main_sycn_pet_tag) as? UIButton
        onlyEggImage = changePetScrollerView.viewWithTag(main_change_egg_tag) as? UIButton
        if  onlyEggImage == nil {
            onlyEggImage = UIButton()
            onlyEggImage!.tag = main_change_egg_tag
            let sycImage = UIImage(named: "egg")
            onlyEggImage!.addTarget(self, action: #selector(eggAddPetAction(_:)), for: .touchUpInside)
            onlyEggImage?.contentMode = .scaleAspectFit
            if eggImage == nil {
                onlyEggImage!.frame = CGRect(x: 4/5*SCREEN_WIDTH, y: petImageView.frame.size.height*3/4, width: petImageView.frame.size.height/4*(sycImage?.size.width)!/(sycImage?.size.height)!, height: petImageView.frame.size.height/4)
            }else{
                onlyEggImage!.frame = (eggImage?.frame)!
            }
            onlyEggImage?.setBackgroundImage(sycImage, for: .normal)
            changePetScrollerView.addSubview(onlyEggImage!)
        }
        if eggImage != nil {
            eggImage?.removeFromSuperview()
        }
    }
    
    func addSynPetInScrollerView() {
        let eggImage : UIButton? = changePetScrollerView.viewWithTag(main_change_egg_tag) as? UIButton
        var synceggImage : UIButton? = changePetScrollerView.viewWithTag(main_sycn_pet_tag) as? UIButton
        if  synceggImage == nil {
            synceggImage = UIButton()
            synceggImage!.tag = main_sycn_pet_tag
            let sycImage = UIImage(named: "sysChonsePet")
            synceggImage!.addTarget(self, action: #selector(showSyncView(_:)), for: .touchUpInside)
            synceggImage?.contentMode = .scaleAspectFit
            if eggImage == nil {
                synceggImage!.frame = CGRect(x: 4/5*SCREEN_WIDTH, y: petImageView.frame.size.height*3/4, width: petImageView.frame.size.height/4*(sycImage?.size.width)!/(sycImage?.size.height)!, height: petImageView.frame.size.height/4)
            }else{
                synceggImage!.frame = (eggImage?.frame)!
            }
            synceggImage?.setBackgroundImage(sycImage, for: .normal)

            changePetScrollerView.addSubview(synceggImage!)
        }
        if eggImage != nil {
            eggImage?.removeFromSuperview()
        }
    }
    
    //MARK: - ScroolerView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if changePetScrollerView.contentOffset.x == 0 {
            changePetScrollerView.contentOffset.x = 1
        }
        let moveX = changePetScrollerView.contentOffset.x
        let changePetX = petImageView.frame.size.width
        let changePetY = petImageView.frame.size.height

        let sizeWith = (SCREEN_WIDTH-changePetX)/2
        let sizeHeight = changePetY*3/4
        
//        let sycImage = UIImage(named: "sysChonsePet")
//        let changeY = sycImage!.size.height
//        let changeX = sycImage!.size.width/changeY*changePetY
        
        let petImage = changePetScrollerView.viewWithTag(main_change_pet_tag)
        var rate = moveX/sizeWith
        if rate > 1 {
            rate = 1
        }
        petImage?.frame = CGRect(x: (1-rate)*sizeWith + 20*rate + moveX, y: sizeHeight*rate,width: (1-rate*3/4)*changePetX, height: (1-rate*3/4)*changePetY)
        
        var eggImage : UIView?
        
        if helper.petModel == .syncPet {
            eggImage = changePetScrollerView.viewWithTag(main_sycn_pet_tag)
        }else{
            eggImage = changePetScrollerView.viewWithTag(main_change_egg_tag)
        }
        
        let xpos = 20*(rate-1) - changePetX*(rate+1)/4 + SCREEN_WIDTH*(2-rate)/2  + moveX
        let ypos = sizeHeight*(1-rate)
        let ewidth = (rate*3/4 + 1/4)*changePetX
        let eheight = (rate*3/4 + 1/4)*changePetY

        eggImage?.frame =  CGRect(x: xpos , y: ypos,width: ewidth, height: eheight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeScrollerViewDidSetView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        changeScrollerViewDidSetView()
    }
    
    func changeScrollerViewDidSetView() {
        
        if changePetScrollerView.contentOffset.x > 40 {
            choosePetTipLabel.isHidden = false
            hidenVolumeButton(true)
            helper.showEggOrPet = .egg
            if helper.petModel == .syncPet {
                choosePetTipLabel.text = String(format: Localizaed("Sync your Gululu to\rwelcome %@!"),GPet.share.changePetName(petName: GPet.share.syncPetName))
            }else{
                choosePetTipLabel.text  = String(format: Localizaed("Let %@\rchoose a new pet!"),GChild.share.getActiveChildName())
            }
            let changePetX = petImageView.frame.size.width

            changePetScrollerView.setContentOffset(CGPoint(x: (SCREEN_WIDTH-changePetX)/2, y: 0), animated: true)
        }else{
            helper.showEggOrPet = .pet
            choosePetTipLabel.isHidden = true
            hidenVolumeButton(false)
            changePetScrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    // MARK: - Load BootPageVC
    func layoutBootPageVC() {
        
        if bootPage == nil && (MainBootHelper.share.readSaveShowBootVCKey(activeChildID)){
            choosePetTipLabel.isHidden = true
            hidenVolumeButton(true)
            
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            bootPage = mainSB.instantiateViewController(withIdentifier: "bootPage") as? BootPageVC
            view.addSubview(bootPage!.view)
            let aswipe = UISwipeGestureRecognizer()
            aswipe.direction = .left
            aswipe.addTarget(self, action: #selector(swipeAc(_:)))
            let tapGeR = UITapGestureRecognizer()
            tapGeR.numberOfTapsRequired = 1
            tapGeR.addTarget(self, action: #selector(tapAction(_:)))
            bootPage?.tipsLabel.text = String(format: Localizaed("Congratulations, %@ has\rfinished the journey!"),GPet.share.changePetName(petName: GPet.share.showPet?.petName))
            bootPage?.tipsLabel.isHighlighted = true
            bootPage?.tipsLabel.highlightedTextColor = .white
            bootPage!.bgMaskImageView.addGestureRecognizer(aswipe)
            bootPage?.bgMaskImageView.addGestureRecognizer(tapGeR)
            bootPage!.view.tag = bootPageTag
            bootPage!.hideButton.addTarget(self, action: #selector(removeBootPage(_:)), for: .touchUpInside)
            
            MainBootHelper.share.saveShowBootVCKey(activeChildID)
        }
    }
    
    func showFinishChangePet() {
        choosePetTipLabel.isHidden = true
        hidenVolumeButton(true)
        
        if bootPage == nil {
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            bootPage = mainSB.instantiateViewController(withIdentifier: "bootPage") as? BootPageVC
            view.addSubview(bootPage!.view)
        }else{
            bootPage?.bgMaskImageView.isUserInteractionEnabled = false
        }
        MainBootHelper.share.removeShowBootVCKeyValue(activeChildID)
        bootPage?.bootMoveImage.isHidden = true
        bootPage!.hideButton.addTarget(self, action: #selector(removeBootPage(_:)), for: .touchUpInside)
        bootPage?.tipsLabel.text = String(format: Localizaed("Look, %@ is coming now!\rI'll see you later!"),GPet.share.changePetName(petName: GPet.share.chosePetName))
    }
    
    @objc func tapAction(_ taP:UITapGestureRecognizer) {
        if helper.showEggOrPet == .egg && GPet.share.chosePetSucced == false{
            GUser.share.appStatus = .changePet
            gotoSelectPetVC()
            let button = UIButton()
            removeBootPage(button)
        }
    }
    
    @objc func eggAddPetAction(_ id:UIButton) {
        id.antiMultiplyTouch(1.0, closure: {})
        GUser.share.appStatus = .changePet
        gotoSelectPetVC()
    }
    
    @objc func showSyncView(_ id:UIButton){
        id.antiMultiplyTouch(1.0, closure: {})
        showNoticeAlter()
    }
    
    @objc func swipeAc(_ swipe:UISwipeGestureRecognizer) {
        if swipe.direction == .right {
            swipe.direction = .left
            bootPage?.tipsLabel.text = String(format: Localizaed("Congratulations, %@ has\rfinished the journey!"),GPet.share.changePetName(petName: GPet.share.showPet?.petName))
            helper.showEggOrPet = .pet
            changePetScrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            swipe.direction = .right
            bootPage?.bootMoveImage.isHidden = true
            bootPage?.tipsLabel.text = String(format:Localizaed("Now, you can let %@\rrestart with a new pet!"),GChild.share.getActiveChildName())
            helper.showEggOrPet = .egg
            changePetScrollerView.setContentOffset(CGPoint(x: SCREEN_WIDTH/4, y: 0), animated: true)
        }
    }
    
    @objc func removeBootPage(_ id:UIButton){
        bootPage?.view.removeFromSuperview()
        bootPage = nil
        if GPet.share.chosePetSucced {
            GPet.share.changeShowPet()
            loadPetImage()
            hidenVolumeButton(false)
            petImageView.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut, animations: {
                self.petImageView.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
                }, completion: { (success:Bool) in
            })
        }else{
            if helper.showEggOrPet == .egg {
                choosePetTipLabel.isHidden = false
                choosePetTipLabel.text  = String(format: Localizaed("Let %@\rchoose a new pet!"),GChild.share.getActiveChildName())
                hidenVolumeButton(true)
            }else{
                choosePetTipLabel.isHidden = true
                hidenVolumeButton(false)
            }
        }
    }
    

    //MARK : - alterView show and reomve
    func showNoticeAlter(){
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let verifyCodeVC: SyncTimeAlterView = mainSB.instantiateViewController(withIdentifier: "syncTimeVC") as! SyncTimeAlterView
        verifyCodeVC.idSelf = self
        UIApplication.shared.keyWindow?.addSubview(verifyCodeVC.view)
        verifyCodeVC.oKButton.addTarget(self, action: #selector(removeAlterView(_:)), for: .touchUpInside)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.turnoverImage.isHidden = true
            verifyCodeVC.topImageView.image = UIImage(named: "syncDone")
        }
    }
    
    @objc func removeAlterView(_ id:UIButton){
        let window = UIApplication.shared.keyWindow?.subviews
        for view :UIView in  window!{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }

}
