//
//  ConfirmPetVC.swift
//  Gululu
//
//  Created by Ray Xu on 30/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import CoreData

class ConfirmPetVC: BaseViewController{

    @IBOutlet weak var Caption: UILabel!
    @IBOutlet weak var petGifView: FLAnimatedImageView!
    @IBOutlet weak var petDescriptLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var petName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let petNameStr = GPet.share.changePetName(petName: GPet.share.chosePetName)
        Caption.text = String(format: Localizaed("You have selected\r%@"),petNameStr)
        petDescriptLabel.text = String(format: Localizaed("%@ will be your partenter to explore the Gululu Universe! And you can unlock more friends when you reach Level 10 ! Ready?"),petNameStr)
        nextButton.setTitle(Localizaed("Yes"), for: .normal)
        let bundle=Bundle.main
        let URL=bundle.url(forResource:GPet.share.getPetImageName(GPet.share.chosePetName), withExtension: "gif")
        
        //let data=NSData.dataWithContentsOfURL(URL!)
        let data=try!  Data(contentsOf: URL!, options: NSData.ReadingOptions.mappedIfSafe)
        let image=FLAnimatedImage(animatedGIFData:(data))
        petGifView.animatedImage=image
    }
    
    override func viewWillDisappear(_ animated: Bool)  {
        super.viewWillDisappear(animated)
        nextButton.isEnabled = true
    }

    @IBAction func ConfirmPetSel(_ sender: AnyObject) {
      //pet create need to connect with cupID which is only avalible after cupWifi bind
        if !checkInternetConnection() {
            return
        }
        if GUser.share.appStatus == .addChild || GUser.share.appStatus == .addPet || GUser.share.appStatus == .registered{
            self .createChildPet()
        }else if GUser.share.appStatus == .changePet{
            addAnotherPet()
        }else if GUser.share.appStatus == .upgradePet{
            upgradePet()
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ConfirmPetVC {
    fileprivate func createChildPet(){
        LoadingView().showLodingInView()
        GPet.share.createChildPet{ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                    case .Success   :   self.createPetSuccess()
                    case .Error     :   self.addAnotherFailed()
                }
            }
        }
    }
    
    func addAnotherPet()  {
        LoadingView().showLodingInView()
        GPet.share.addAnotherPet{ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                case .Success :
                    GPet.share.chosePetSucced = true
                    _ = self.navigationController?.popToRootViewController(animated: true)
                case .Error   :
                    self.addAnotherFailed()
                }
            }
        }
    }
    
    func addAnotherFailed(){
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Pet creat failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func upgradePet() {
        LoadingView().showLodingInView()
        if GCup.share.readCupIDFromDB() == ""{
            LoadingView().stopAnimation()
            return
        }
        GPet.share.upgradePet{ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                case .Success :
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: PetStatusNotifacationName), object: nil)
                    MainUpgrade.shareInstance.updatePetGradeStatus("upgrading")
                    for VC : UIViewController in (self.navigationController?.viewControllers)!{
                        if VC .isKind(of: UpgradeView.self){
                            GPet.share.chosePetSucced = true
                            _ = self.navigationController?.popToViewController(VC, animated: true)
                        }
                    }
                case .Error   :  self.addAnotherFailed()
                }
            }
        }
    }
    
    func createPetSuccess() -> Void {
        GPet.share.chosePet  = nil
        goto(vcName: "finishChosePet", boardName: "ChosePet")
    }

}




