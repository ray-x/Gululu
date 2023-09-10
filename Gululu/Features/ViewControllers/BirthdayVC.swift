//
//  BirthdayVC.swift
//  Gululu
//
//  Created by Ray Xu on 5/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class BirthdayVC: BaseViewController {

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
       if GUser.share.appStatus == .changeProfile{
            nextButton.title = DONE
            let name = GChild.share.getActiveChildName()
            caption.text = String(format: Localizaed("When is %@'s birthday"),name)
            birthdayPicker.date = BKDateTime.getDateFromStr("yyyy-MM-dd",dateStr: RecommendWaterHelper.share.getBirthdayFormat(GUser.share.activeChild?.birthday))
            if Common.checkPreferredLanguagesIsEn() {
                birthdayLabel.text = BKDateTime.getDateStrFormDate("MMM. dd, yyyy", date: birthdayPicker.date)
            }else{
                birthdayLabel.text = BKDateTime.getDateStrFormDate("yyyy年MMMdd日", date: birthdayPicker.date)
            }
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let date = Date()
        birthdayPicker.maximumDate = date
		birthdayPicker.backgroundColor = .white
        if GUser.share.appStatus == .addChild || GUser.share.appStatus == .registered {
            nextButton.title = NEXT
            var name = GUser.share.workingChild?.childName
            if name == nil{
                name = GChild.share.getActiveChildName()
            }

            caption.text = String(format: Localizaed("When is %@'s birthday"),name!)
            if Common.checkPreferredLanguagesIsEn() {
                birthdayLabel.text = BKDateTime.getDateStrFormDate("MMM. dd, yyyy", date: birthdayPicker.date)
            }else{
                birthdayLabel.text = BKDateTime.getDateStrFormDate("yyyy年MMMdd日", date: birthdayPicker.date)
            }
            GUser.share.workingChild?.birthday = BKDateTime.getDateStrFormDate("yyyy/MM/dd", date: birthdayPicker.date)
        }
    }
        
    @IBAction func datePickerChange(_ sender: Any) {
        if Common.checkPreferredLanguagesIsEn() {
            birthdayLabel.text = BKDateTime.getDateStrFormDate("MMM. dd, yyyy", date: birthdayPicker.date)
        }else{
            birthdayLabel.text = BKDateTime.getDateStrFormDate("yyyy年MMMdd日", date: birthdayPicker.date)
        }
    }

    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoWeightVC(_ sender: AnyObject) {
  	if !checkInternetConnection() {
            return
        }
        if GUser.share.appStatus == .changeProfile {
            let datePickerStr = BKDateTime.getDateStrFormDate("yyyy-MM-dd", date: birthdayPicker.date)
            if datePickerStr == RecommendWaterHelper.share.getBirthdayFormat(GUser.share.activeChild?.birthday) {
               _ =  self.navigationController?.popViewController(animated: true)
            }else{
                GUser.share.activeChild?.birthday = BKDateTime.getDateStrFormDate("yyyy/MM/dd", date: birthdayPicker.date)
                updateChilren()
            }
        }else{
            GUser.share.workingChild?.birthday = BKDateTime.getDateStrFormDate("yyyy/MM/dd", date: birthdayPicker.date)
            goto(vcName: "weightVC", boardName: "Register")
        }
    }
}

extension BirthdayVC{
    
    func updateChilren() -> Void {
        if !checkInternetConnection(){
            return
        }
        LoadingView().showLodingInView()
        GUser.share.activeChild!.update(.update, uiCallback: { result in
            DispatchQueue.main.async { 
                LoadingView().stopAnimation()
                if result.boolValue{
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Alter birthday failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
}
