//
//  WeightVC.swift
//  Gululu
//
//  Created by Ray Xu on 5/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class WeightVC: BaseViewController , UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    var InternetWarningMsgbox:WifiPopupView?
    let connStatus=NetworkStatusNotifier()
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var privacyButton: UIButton!
    
    var weight=25
    var unit="kg"
    var base=10
    
    var originStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightPicker.backgroundColor = .white
        weightPicker.delegate=self
        
        if GUser.share.appStatus == .changeProfile {
            nextButton.title = DONE
            setViewData(GUser.share.activeChild!)
        }else{
            nextButton.title = NEXT
            setViewData(GUser.share.workingChild!)
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)

    }
    
    func setViewData(_ child:Children) {
        var base = 10
        if child.unit != nil {
            unit = child.unit!
        }else {
            unit = "kg"
            child.unit = unit
            child.weight = weight as NSNumber?
        }
        
        if unit == "lbs" {
            base = 20
            weight = (child.weightLbs == nil) ? 25:(child.weightLbs?.intValue)!
        }else{
            base = 10
            weight = (child.weight == nil) ? 10:(child.weight?.intValue)!
        }
        if weight-base<0 {
            weight = base
        }
        weightLabel.text="\(weight) \(unit)"
        
        let rowNumber = (unit=="kg") ? 0:1
        weightPicker.selectRow(weight-base, inComponent: 0, animated: true)
        weightPicker.selectRow(rowNumber, inComponent: 1, animated: true)
        
        var name = child.childName
        if name == nil{
            name = GChild.share.getActiveChildName()
        }

        caption.text = String(format: Localizaed("What is %@'s weight?"),name!)

    }
    
    //MARK: picker delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            base = (unit == "lbs") ? 20 : 10
            weight=row+base
            weightLabel.text="\(weight) \(unit)"
        }else{
            unit = (row==0) ? "kg" : "lbs"
            base = (unit == "lbs") ? 20 : 10
            
            if weight-base<0 {
                weight = base
            }
            weightPicker.reloadComponent(0)
            weightPicker.selectRow(weight-base, inComponent: 0, animated: true)
            weightLabel.text="\(weight) \(unit)"
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return pickerData.count
        if unit=="kg" {
            if component == 0 {
                return 241
            }else {
                return 2
            }
        }else{
            if component == 0 {
                return 531
            }else{
                return 2
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var base=10
        if unit == "lbs" {base=20}
        if component == 0 {
            return "     \(row+base)  "
        }else {
            if row == 0 {
                return "kg     "
            }else {
                return "lbs    "
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    @IBAction func gotoRecommandVC(_ sender: AnyObject) {
 	
        if GUser.share.appStatus == .changeProfile {
            if  checkIsNeedToUpdate(){
                setModelData(GUser.share.activeChild!)
                updateChilren()
            } else {
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            setModelData(GUser.share.workingChild!)
            goto(vcName: "recommandVC", boardName: "Register")
        }
    }
    
    func checkIsNeedToUpdate() -> Bool {
        if unit == GUser.share.activeChild?.unit {
            if unit == "lbs" {
                if NSNumber(value: weight) == GUser.share.activeChild?.weightLbs {
                    return false
                }else{
                    return true
                }
            } else {
                if NSNumber(value: weight) == GUser.share.activeChild?.weight{
                    return false
                }else{
                    return true
                }
            }
        }else{
            return true
        }
    }
    
    func setModelData(_ child:Children) {
        child.unit = unit
        if unit == "lbs" {
            child.weightLbs = weight as NSNumber?
            child.weight = nil
        } else {
            child.weight = weight as NSNumber?
            child.weightLbs = nil
        }
    }
}

extension WeightVC{
    
    func updateChilren() -> Void {
        if !checkInternetConnection() {
            return
        }
        LoadingView().showLodingInView()
        GUser.share.activeChild!.update(.update, uiCallback: { result in
            DispatchQueue.main.async { 
                LoadingView().stopAnimation()
                if result.boolValue{
                   // GUser.share.activeChild = createObject(Children.self, objectID: childID)
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Alter weight failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
}


