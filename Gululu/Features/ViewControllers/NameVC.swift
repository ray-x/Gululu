
//
//  NameVC.swift
//  Gululu
//
//  Created by Ray Xu on 4/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class NameVC: BaseViewController, UITextFieldDelegate
{

    @IBOutlet weak var childName: UITextField!
 
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nameTitile: UILabel!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    var originName = ""

    
    override func viewDidLoad(){
        super.viewDidLoad()
        childName.becomeFirstResponder()
        childName.setValue(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) , forKeyPath: "_placeholderLabel.textColor")
        nameTitile.text = Localizaed("What's your child's nickname?")
        childName.placeholder = Localizaed("Nickname")
        if GUser.share.appStatus == .changeProfile {
            childName.text = GChild.share.getActiveChildName()
            nextButton.setTitle(DONE, for: .normal)
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GUser.share.addChildSucced = false
        originName = GChild.share.getActiveChildName()
        if GUser.share.appStatus != .changeProfile{
             nextButton.setTitle(NEXT, for: .normal)
            if GUser.share.workingChild == nil {
                GUser.share.workingChild = createObject(Children.self)!
            }
            if GUser.share.workingChild?.childID == nil {
                GUser.share.workingChild?.childID = GUser.share.workingChildID
            }
            if GUser.share.workingChild?.childName != nil {
                childName.text = GUser.share.workingChild?.childName
            }
        }
        if GUser.share.appStatus == .registered{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func textChange(_ sender: Any) {
        let toBeString = childName.text!
        
        let curLang = childName.textInputMode?.primaryLanguage
        if curLang == "zh-Hans"{
            if (childName.markedTextRange == nil){
                limitChildNameLength(toBeString)
            }
        }else{
            limitChildNameLength(toBeString)
        }
    }

	func limitChildNameLength(_ toBeString: String){
		var cotValue = (textLen: 0, cnNum: 0, hasUni: false)
		cotValue = Common.checkTextLengthAndChineseNums(toBeString)
		if cotValue.textLen > 10{
			var endIndex = NSInteger()
			if cotValue.textLen >= 11{
				if cotValue.cnNum > 0{
					if (cotValue.textLen % 2) == 1 { cotValue.textLen -= 1 }
					let charNum = cotValue.textLen - (cotValue.cnNum * 2)
					endIndex = ((10 - charNum) / 2) + charNum
				}else{
					endIndex = 10
				}
			}else{
				endIndex = cotValue.textLen - cotValue.cnNum - 1
			}
			childName.text = (toBeString as NSString).substring(with: NSRange(location: 0, length: endIndex))
		}
		
		if cotValue.hasUni{
			childName.enablesReturnKeyAutomatically = true
		}
	}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""{
            return true
        }
        if string == " "{
            return false
        }
        if Common.checkStrHaveEmoji(string){
            return false
        }
        return true
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gotoSexVC(textField)
        return true
    }
    
    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    @IBAction func textFieldEditChanged(_ sender: AnyObject) {
        if childName.text == nil || childName.text == "" {
            nextButton.alpha = 0.5
            nextButton.isEnabled = false
        }else{
            nextButton.alpha = 1.0
            nextButton.isEnabled = true
        }
    }

    @IBAction func gotoSexVC(_ sender: AnyObject) {
        let str = childName.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if str == nil || str == ""{
            let alertView = BHAlertView(frame: view.frame)
            alertView.initAlertContent("", message: Localizaed("Child name should not be nil"), leftBtnTitle: OK, rightBtnTitle: "")
            alertView.presentBHAlertView()
            return
        }  
        if Common.checkStrHaveEmoji(str!){
            let alertView = BHAlertView(frame: view.frame)
            alertView.initAlertContent("", message: Localizaed("Child name should not have emoji"), leftBtnTitle: OK, rightBtnTitle: "")
            alertView.presentBHAlertView()
            return
        }
        if GUser.share.appStatus == .changeProfile {
            if GChild.share.getActiveChildName() == childName.text {
                _ = navigationController?.popViewController(animated: true)
            }else if GUser.share.isExistInChildList(str!) {
                let alertView = BHAlertView(frame: view.frame)
                alertView.initAlertContent("", message: Localizaed("You already have a child with this name."), leftBtnTitle: OK, rightBtnTitle: "")
                alertView.presentBHAlertView()
            }else{
                updateChilren(childName: str!)
            }
        }else{
            if GUser.share.isExistInChildList(str!) {
                let alertView = BHAlertView(frame: view.frame)
                alertView.initAlertContent("", message: Localizaed("You already have a child with this name."), leftBtnTitle: OK, rightBtnTitle: "")
                alertView.presentBHAlertView()
                return
            }
            GUser.share.workingChild?.childName = str
            goto(vcName: "choseSexVC", boardName: "Register")
        }
    }
}

extension NameVC{
    
    func updateChilren(childName:String) -> Void {
        if !checkInternetConnection(){
            return
        }
        LoadingView().showLodingInView()
        let child : Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return
        }
        child!.childName = childName
        child!.update(.update, uiCallback: { result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result.boolValue{
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    child?.childName = self.originName
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Alter name failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
}
