//
//  FinishPetSelectVC.swift
//  Gululu
//
//  Created by w19787 on 16/6/11.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class FinishPetSelectVC: BaseViewController {

    @IBOutlet weak var petGifView: FLAnimatedImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var greatLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let female_greeting = Localizaed("has got her pet, and it’s time to add a Gululu for her!")
        let male_greeting = Localizaed("has got his pet, and it’s time to add a Gululu for him!")
        finishButton.setTitle(Localizaed("Finish"), for: .normal)
        greatLabel.text = Localizaed("Great")
        let bundle=Bundle.main
        let URL=bundle.url(forResource: GPet.share.getPetImageName(GPet.share.chosePetName), withExtension: "gif")
        let data=try!  Data(contentsOf: URL!, options: NSData.ReadingOptions.mappedIfSafe)
        let image=FLAnimatedImage(animatedGIFData:(data))
        petGifView.animatedImage=image
        
        if GUser.share.activeChild?.gender == "boy"  {
            greetingLabel.text = GChild.share.getActiveChildName() + " " + male_greeting
        }  else {
            greetingLabel.text = GChild.share.getActiveChildName() + " " + female_greeting
        }
    }

    @IBAction func finishPetSelect(_ sender: UIButton){
        
        updateActiveChild()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoNextVC() -> Void {
        if GUser.share.appStatus == .addChild || GUser.share.appStatus == .registered {
            GUser.share.addChildSucced = true
        }
        let sb=UIStoryboard(name: "Main", bundle: nil)
        let rootVC=navigationController?.viewControllers[0]
        if rootVC!.isKind(of: MainVC.self) {
            _ = navigationController?.popToRootViewController(animated: true)
        }else{
            let vc:MainVC=sb.instantiateViewController(withIdentifier: "showMainVC") as! MainVC
            vc.helper.childrenDisplayed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FinishPetSelectVC{
    func updateActiveChild() -> Void {
        if !checkInternetConnection() {
            return
        }
        LoadingView().showLodingInView()
        let child:Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return
        }
        child!.hasPet = 1
        child!.update(.fetch, uiCallback: { result in
            DispatchQueue.main.async { 
                LoadingView().stopAnimation()
                if result.boolValue{
                    self.gotoNextVC()
                }else{
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Child update failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
}
