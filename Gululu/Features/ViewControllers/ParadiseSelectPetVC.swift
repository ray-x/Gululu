//
//  ParadiseSelectPetVC.swift
//  Gululu
//
//  Created by baker on 2017/11/22.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
////import Flurry_iOS_SDK

extension PetParadiseVC{
    func showSelectPetView() {
        if petSelectView == nil{
            petSelectView = UIView(frame: self.view.bounds)
            petSelectView?.backgroundColor = UIColor(white: 0, alpha: 0.75)
            petSelectView?.tag = petParadiseHelper.change_model_pet_animtaion_image_tag
            addBackButtonInPetSelectView()
            addSelectPetFromPetArray()
            self.view.addSubview(petSelectView!)
        }else{
            petSelectView?.isHidden = false
            startPetAnimation()
        }
    }
    
    func startPetAnimation() {
        let nextPetArray = petParadiseHelper.getNextPetArray()
        if nextPetArray.count == 0{
            return
        }
        let count : Int = nextPetArray.count
        for i in 1...count{
            let animationView:UIImageView? = self.view.viewWithTag(petParadiseHelper.change_model_pet_animtaion_image_tag+i) as? UIImageView
            if animationView != nil{
                animationView!.startAnimating()
            }
//            animationView?.alpha = 0.1
//            UIView.animate(withDuration: 1.0) {
//                animationView?.alpha = 1.0
//            }
        }
    }
    
    func addBackButtonInPetSelectView() {
        let button = UIButton(frame: self.backButton.frame)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(removeSelectPetView), for: .touchUpInside)
        petSelectView?.addSubview(button)
    }
    
    func addSelectPetFromPetArray() {
        petParadiseHelper.petArray = petParadiseHelper.getNextPetArray()
        if petParadiseHelper.petArray?.count == 0{
            return
        }
        let animationWidth = FIT_SCREEN_WIDTH(170)
        let twoPetImageWidth = FIT_SCREEN_WIDTH(20)
        let animationHeight = animationWidth*1.8
        let count : Int = petParadiseHelper.petArray!.count
        for i in 1...count{
            let x1 = SCREEN_HEIGHT/2 - animationWidth/2 - (twoPetImageWidth + animationWidth) * CGFloat(count - 1)/2
            let x2 = (CGFloat(i) - 1)*(twoPetImageWidth+animationWidth)
            let x =  x1 + x2
            let petImage = UIImageView()
            petImage.tag = i+petParadiseHelper.change_model_pet_animtaion_image_tag
            petImage.isUserInteractionEnabled = true
            petImage.frame = CGRect(x: x, y: FIT_SCREEN_WIDTH(30), width: animationWidth, height: animationHeight)
            petImageAddAnimaiton(petImage, petName: petParadiseHelper.petArray?[i-1])
            petSelectView?.addSubview(petImage)
            createMiddleView(petImage, petName: petParadiseHelper.petArray?[i-1])
        }
    }
    
    func createMiddleView(_ lodingImageView: UIImageView, petName:String?)  {
        let pet_view = UIView()
        pet_view.backgroundColor = .clear
        pet_view.alpha = 0.1
        lodingImageView.alpha = 0.1
        lodingImageView.addSubview(pet_view)
        pet_view.tag = lodingImageView.tag
        pet_view.snp.makeConstraints { (contentView) in
            contentView.centerX.equalTo(lodingImageView)
            contentView.top.equalTo(lodingImageView).offset(FIT_SCREEN_WIDTH(60))
            contentView.width.equalTo(lodingImageView)
            contentView.bottom.equalTo(lodingImageView).offset(-FIT_SCREEN_WIDTH(110))
        }
        createPetImage(pet_view, petName: petName)
        createConfirmButton(pet_view)
        UIView.animate(withDuration: 0.5) {
            pet_view.alpha = 1.0
            lodingImageView.alpha = 1.0
        }
    }
    
    func createPetImage(_ lodingImageView: UIView, petName:String?) {
        let petImageViewWidth = FIT_SCREEN_WIDTH(70)
        let petImageView = UIImageView()
        petImageView.image = UIImage(named: GPet.share.getPetImageName(petName))
        lodingImageView.addSubview(petImageView)
        petImageView.snp.makeConstraints { (contentView) in
            contentView.centerX.equalTo(lodingImageView)
            contentView.top.equalTo(lodingImageView).offset(10)
            contentView.size.equalTo(CGSize(width: petImageViewWidth, height: petImageViewWidth))
        }
    }
    
    func createConfirmButton(_ lodingImageView: UIView) {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: BASEFONT, size: 13)
        button.setBackgroundImage(UIImage(named: "green_button"), for: .normal)
        button.setTitle(Localizaed("Choose"), for: .normal)
        button.tag = lodingImageView.tag
        button.addTarget(self, action: #selector(chose_next_pet(sender:)), for: .touchUpInside)
        lodingImageView.addSubview(button)
        button.snp.makeConstraints { (contentView) in
            contentView.centerX.equalTo(lodingImageView)
            contentView.bottom.equalTo(lodingImageView).offset(-10)
            contentView.size.equalTo(CGSize(width: FIT_SCREEN_WIDTH(50), height: FIT_SCREEN_WIDTH(45)))
        }
    }
    
    func petImageAddAnimaiton(_ lodingImageView: UIImageView, petName:String?) {
        var imagesListArray :[UIImage] = []
        for position in 0...25
        {
            let petNameAnimation = petParadiseHelper.getChoseNextPetAinmationName(petName)
            let strImageName : String = String(format: "%@%02d.png", petNameAnimation, position*2)
            let image  = UIImage(named:strImageName)
            imagesListArray.append(image!)
        }
        lodingImageView.image = imagesListArray.last
        
        lodingImageView.animationImages = imagesListArray
        lodingImageView.animationDuration = 1
        lodingImageView.animationRepeatCount = 1
        UIView.setAnimationDelay(0.5)
        lodingImageView.startAnimating()
        lodingImageView.contentMode=UIViewContentMode.scaleAspectFit
    }
    
    @objc func chose_next_pet(sender:UIButton) {
        //Flurry.logEvent("Pet_view_chose_new_pet_btn_click")
        let loadView = LoadingView()
        loadView.showLodingInView()
        loadView.lodingImageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        let chosePetName = petParadiseHelper.petArray?[sender.tag-1001]
        GPet.share.add_next_pet(chosePetName!, { result in
            DispatchQueue.main.async {
                loadView.stopAnimation()
                if result == 0{
                    GPet.share.showPetStatus = .sync
                    GPet.share.can_add_pet = false
                    self.removeSelectPetView()
                    self.resetAddNextPetSuccess()
                }else if result == 1{
                    self.showCannotSupportDonny()
                }else{
                    self.addAnotherFailed()
                }
            }
        })
    }
    
    func showCannotSupportDonny() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.backView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        alertView.initAlertContent("", message: Localizaed("The game version of your Gululu is out of date, please put it in the charging dock to update the new features."), leftBtnTitle: GOTIT, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func resetAddNextPetSuccess() {
        for view : UIView in PetScrollView.subviews {
            if view.tag > 50{
                view.removeFromSuperview()
            }
        }
        updateAllPetList()
    }
    
    func addAnotherFailed(){
        let alertView = BHAlertView(frame: view.frame)
        alertView.backView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        alertView.initAlertContent("", message: Localizaed("Add pet failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    @objc func removeSelectPetView() {
        petSelectView?.isHidden = true
    }
}
