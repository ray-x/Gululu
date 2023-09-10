//
//  PhotoSelVC.swift
//  Gululu
//
//  Created by Ray Xu on 4/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class PhotoSelVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var choose: UILabel!
    @IBOutlet weak var photoSelButton: UIButton!
    @IBOutlet weak var maskViewHolder: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    var choseChildHeadImage : UIImage!
    var changeChildAvator : Bool = false
    override func viewDidLoad(){
        super.viewDidLoad()
        if GUser.share.appStatus == .changeProfile {
            let childNameStr : String = GChild.share.getActiveChildName()
            choose.text = String(format: Localizaed("Choose a photo for %@"),childNameStr)
            nextButton.setTitle(DONE, for: .normal)
            let imagePath: String! = activeChildID + ".jpg"
            layoutMaskView(imagePath)
            refleshPhotoVC(true)
        }else{
            var childNameStr : String? = (GUser.share.workingChild?.childName)!
            if childNameStr == nil{
                childNameStr = GUser.share.activeChild?.childName
            }

            choose.text = String(format: Localizaed("Choose a photo for %@"),childNameStr!)
            nextButton.setTitle(NEXT, for: .normal)
            refleshPhotoVC(false)
        }
        privacyButton.setAttributedTitle(GULabelUtil().setJustPrivacyPolicyButton(Localizaed("Privacy Policy.")), for: .normal)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(AvatorHelper.share.choseAvatar != nil)
        {
            choseChildHeadImage = AvatorHelper.share.choseAvatar
            setPhotoImageHead()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if GUser.share.appStatus == .changeProfile {
            AvatorHelper.share.choseAvatar = nil
            AvatorHelper.share.choseAvatarInfo = nil
        }
    }
    
    func layoutMaskView(_ imagePath:String) {
        var avatroImage : ImageMaskView? = maskViewHolder.viewWithTag(avatroImageTag) as? ImageMaskView
        if avatroImage == nil {
            let Rect = CGRect(x: 0, y: 0, width: FIT_SCREEN_WIDTH(132), height: FIT_SCREEN_WIDTH(132))
            avatroImage = ImageMaskView(frame: Rect)
            avatroImage!.tag = avatroImageTag
        }
        avatroImage!.imagePath = imagePath
        avatroImage!.layoutSubviews()
        maskViewHolder.insertSubview(avatroImage!, belowSubview: photoSelButton)
    }
    
    func refleshPhotoVC(_ isHaveImageURL:Bool) -> Void {
        if isHaveImageURL {
            photoSelButton.setTitle("", for: .normal)
            photoSelButton.setBackgroundImage(UIImage(), for: .normal)
        }else{
            photoSelButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 22)
            photoSelButton.setTitle(Localizaed("Choose\rphoto"), for: .normal)
            photoSelButton.titleLabel?.textAlignment = NSTextAlignment.center
            
        }
    }
    @IBAction func showPrivacy(_ sender: Any) {
        showPrivacyVC()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
	
    @IBAction func photoSelection(_ sender: Any) {
        choseAvatorFromService()
    }
    
    func choseAvatorFromSysterm()  {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choseAvatorFromService() {
        goto(vcName: "ChoseAvatorID", boardName: "Register")
    }
    
	// MARK: UIImagePickerController Delegate
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
	{
		if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
		{
            let scaledImage = BKImage.scaleImageSize(pickedImage)
            choseChildHeadImage = scaledImage
            
            dismiss(animated: true, completion: {
                self.setPhotoImageHead()
            })
		}
	}
    
    func setPhotoImageHead() -> Void {
        
        refleshPhotoVC(true)
        var idStr = String()
        if GUser.share.appStatus == .changeProfile {
            if activeChildID != "" {
                let fileURl : URL =   AvatorHelper.share.getBackImageInDocumentPathURLWithID(activeChildID)
                AvatorHelper.share.writeDocumetFormPath(fileURl.path,andImage: choseChildHeadImage)
                changeChildAvator = true
                idStr  = String(format: "%@_back.jpg", activeChildID)
            }
        }else{
            if GUser.share.workingChild?.childID != nil{
                let fileURl : URL =   AvatorHelper.share.getBackImageInDocumentPathURLWithID((GUser.share.workingChild?.childID)!)
                AvatorHelper.share.writeDocumetFormPath(fileURl.path,andImage: choseChildHeadImage)
                GUser.share.workingChildChosePhoto = true
                idStr  = String(format: "%@_back.jpg", (GUser.share.workingChild?.childID!)!)
            }
        }
        layoutMaskView(idStr)
    }
    
    @IBAction func gotoBrithdayVC(_ sender: AnyObject) {
 
        if GUser.share.appStatus == .changeProfile {
            if changeChildAvator {
                updateAvatorToServer()
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
        }else{
            goto(vcName: "birthdayVC", boardName: "Register")
        }
    }
    
}

extension PhotoSelVC{
    
    func updateAvatorToServer(){
        if !checkInternetConnection() {
            return
        }
        LoadingView().showLodingInView()
        AvatorHelper.share.childChoseAvatorPushService { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                case.Success : _ = self.navigationController?.popViewController(animated: true)
                case.Error  : self.updateChildAvatorFalied()
                }
            }
        }
    }
    
    func updateChildAvatorFalied() {
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.initAlertContent("", message: Localizaed("Upload avator failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
}

