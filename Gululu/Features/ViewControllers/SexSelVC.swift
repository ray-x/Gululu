//
//  SexSelVC.swift
//  Gululu
//
//  Created by Ray Xu on 4/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

enum ChileSex {
    case boy, girl
}

class SexSelVC: BaseViewController {

    var sex : ChileSex = .boy
    
    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    var originStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GUser.share.appStatus == .changeProfile {
            let name = GChild.share.getActiveChildName()
            originStr = (GUser.share.activeChild?.gender)!
            caption.text = String(format: Localizaed("What is %@'s gender?"),name)
            nextButton.setTitle(DONE, for: .normal)
            if originStr == "girl"{
                sex = .girl
            }else{
                sex = .boy
            }
        }else{
            var name = GUser.share.workingChild?.childName
            if name == nil{
                name = GChild.share.getActiveChildName()
            }
 
            caption.text = String(format: Localizaed("What is %@'s gender?"),name!)
            nextButton.setTitle(NEXT, for: .normal)
            if GUser.share.workingChild?.gender == "girl"{
                sex = .girl
            }else{
                sex = .boy
            }
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)

        setViewStyle()
    }
    
    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    @IBAction func ChoseAction(_ sender: AnyObject) {
        if sender as! NSObject == boyButton {
            sex = .boy
        }else {
            sex = .girl
        }
        setViewStyle()
    }
    

    func setViewStyle() -> Void {
        if(sex == .boy){
            boyButton.setBackgroundImage(UIImage(named: "boy_open"), for: .normal)
            girlButton.setBackgroundImage(UIImage(named: "girl_close"), for: .normal)
        }else{
            boyButton.setBackgroundImage(UIImage(named: "boy-1"), for: .normal)
            girlButton.setBackgroundImage(UIImage(named: "girl-3"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoPhotoVC(_ sender: AnyObject) {
       
        if GUser.share.appStatus == .changeProfile {
            if checkNeedToUptate(){
                updateChilren()
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            if sex == .boy {
                GUser.share.workingChild?.gender = "boy"
            }else{
                GUser.share.workingChild?.gender = "girl"
            }
            goto(vcName: "photoSelVC", boardName: "Register")
        }
        
       
    }
    
    func checkNeedToUptate() -> Bool{
        var str = String()
        if sex == .boy {
            str = "boy"
        }else{
            str = "girl"
        }
        if str == GUser.share.activeChild?.gender {
            return false
        }else{
            GUser.share.activeChild?.gender = str
            return true
        }
    }

}

extension SexSelVC{
    
    func updateChilren() -> Void {
        if !checkInternetConnection() {
            return
        }
        LoadingView().showLodingInView()
        GUser.share.activeChild!.update(.update, uiCallback: { result in
            DispatchQueue.main.async { 
                LoadingView().stopAnimation()
                if result.boolValue{
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                     GUser.share.activeChild?.gender = self.originStr
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Alter sex failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
}
