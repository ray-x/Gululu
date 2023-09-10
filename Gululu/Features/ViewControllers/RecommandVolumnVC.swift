//
//  RecommandVolumnVC.swift
//  Gululu
//
//  Created by Ray Xu on 11/01/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

class RecommandVolumnVC: BaseViewController {

    @IBOutlet weak var Caption: UILabel!
    @IBOutlet weak var recommandVolumn: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cutButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    
    let recommendHelper = RecommendWaterHelper.share

    override func viewDidLoad() {
        super.viewDidLoad()
        Caption.lineBreakMode =  .byWordWrapping
        if GUser.share.appStatus == .changeProfile{
            nextButton.setTitle(DONE, for: .normal)
            getRateList()
            showAgeAndWeight()
        }else{
            nextButton.setTitle(NEXT, for: .normal)
            nextButton.isEnabled = false
            var name = GUser.share.workingChild?.childName
            if name == nil{
                name = GChild.share.getActiveChildName()
            }
            if GUser.share.isChildCreated{
                updateChilren()
            } else {
                createChildren()
            }
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)

    }
    
    func showAgeAndWeight() {
        weightLabel.text = recommendHelper.countChildWeight()
        ageLabel.text = recommendHelper.countChildAge(GUser.share.activeChild?.birthday)
    }
    
    func showAlterRecommendValueView() {
        var name : String = ""
        if GUser.share.appStatus == .changeProfile{
            name = (GUser.share.activeChild?.childName)!
        }else{
            name = (GUser.share.workingChild?.childName)!
        }
        
        let str =  String(format: Localizaed("%@'s daily water intake target:"),name)
        Caption.text = str

        setTipsLabelValue()
        cutButton.isHidden = false
        addButton.isHidden = false
        tipsLabel.isHidden = false
        nextButton.isEnabled = true
        addButton.isEnabled = recommendHelper.checkAddButtonEnable()
        cutButton.isEnabled = recommendHelper.checkCutButtonEnable()
    }
    
    func showNoRecommendValueView() {
        tipsLabel.isHidden = true
        cutButton.isHidden = true
        addButton.isHidden = true
        var name : String = ""
        if GUser.share.appStatus == .changeProfile{
            name = GChild.share.getActiveChildName()
        }else{
            name = (GUser.share.workingChild?.childName)!
            if !isValidString(name){
              name = GChild.share.getActiveChildName()
            }
        }
        Caption.text = String(format: Localizaed("%@'s daily water intake target:"),name)
        recommandVolumn.text = recommendHelper.getChoseRateRecommendWaterLabelStr(GUser.share.activeChild?.unit)
        nextButton.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextStep(_ sender: AnyObject){

        if GUser.share.appStatus == .changeProfile{
            if recommendHelper.is_need_to_upload_rate(){
                updateRecommendWater()
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            if GUser.share.workingChildChosePhoto {
                updateAvatorToServer()
            }
            if recommendHelper.is_need_to_upload_rate(){
                updateRecommendWater()
            }else{
                gotoNextVC()
            }
        }
    }
    
    func gotoNextVC() -> Void {
        if GUser.share.appStatus == .changeProfile{
            _ = navigationController?.popViewController(animated: true)
        }else{
            goto(vcName: "PetSelectionVC", boardName: "ChosePet")
        }
    }
    
    @IBAction func add(_ sender: Any) {
        recommendHelper.add_water_rate()
        setTipsLabelValue()
        addButton.isEnabled = recommendHelper.checkAddButtonEnable()
        cutButton.isEnabled = recommendHelper.checkCutButtonEnable()
    }
    
    @IBAction func cutDown(_ sender: Any) {
        recommendHelper.cut_water_rate()
        setTipsLabelValue()
        addButton.isEnabled = recommendHelper.checkAddButtonEnable()
        cutButton.isEnabled = recommendHelper.checkCutButtonEnable()
    }
    
    func setTipsLabelValue() {
        tipsLabel.text = recommendHelper.getDetailInfoFrom_rate(recommendHelper.choseRateInfo.rate!)
        recommandVolumn.text = recommendHelper.getChoseRateRecommendWaterLabelStr(GUser.share.activeChild?.unit)
    }
    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
}

extension RecommandVolumnVC{

    func createChildren() -> Void {
        LoadingView().showLodingInView()
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        GUser.share.createChildren { (result) in
            LoadingView().stopAnimation()
            DispatchQueue.main.async {
                if result {
                    self.getRateList()
                    self.showAgeAndWeight()
                }else{
                    self.showCreateChildFalied()
                }
            }
        }
    }
    
    func updateChilren() -> Void {
        LoadingView().showLodingInView()
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        GUser.share.updateChilren { (result) in
            LoadingView().stopAnimation()
            DispatchQueue.main.async {
                if result {
                    self.getRateList()
                    self.showAgeAndWeight()
                }else{
                    self.recommandVolumn.text = String(GChild.share.defaultRecommendValue)
                    self.showUpdateChildFalied()
                }
            }
        }
    }
    
    func showCreateChildFalied() {
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.initAlertContent("", message: Localizaed("Child create failed"), leftBtnTitle: "Done", rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func showUpdateChildFalied() {
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.initAlertContent("", message: Localizaed("Child update info failed"), leftBtnTitle: "Done", rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func showAlterUpdateChildDrinkWaterFailed() {
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.initAlertContent("", message: Localizaed("Update child drink water failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func getRateList(){
        LoadingView().showLodingInView()
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        recommendHelper.get_child_recommend_water_rate_list { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result {
                    self.showAlterRecommendValueView()
                }else{
                    self.showNoRecommendValueView()
                }
            }
        }
    }
    
    func updateRecommendWater() {
        LoadingView().showLodingInView()
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        recommendHelper.put_child_recommend_water_rate(recommendHelper.choseRateInfo.rate, cloudCallback: { result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result {
                    self.gotoNextVC()
                }else{
                    self.showAlterUpdateChildDrinkWaterFailed()
                }
            }
        })
    }
    
    func updateAvatorToServer() {
        LoadingView().showLodingInView()
        if !checkInternetConnection() {
            LoadingView().stopAnimation()
            return
        }
        AvatorHelper.share.childChoseAvatorPushService { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                case.Success : GUser.share.workingChildChosePhoto = false
                case.Error   : LoadingView().stopAnimation()
                }
            }
        }
    }
}

