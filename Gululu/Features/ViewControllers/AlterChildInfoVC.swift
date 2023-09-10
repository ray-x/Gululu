//
//  AlterChildInfoVC.swift
//  Gululu
//
//  Created by Baker on 16/8/22.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit



class AlterChildInfoVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource,BHAlertViewDelegate{
    
    @IBOutlet weak var avatorImage: UIButton!
    
    @IBOutlet weak var recommendWaterLabel: UILabel!

    @IBOutlet weak var itemTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var maskHeadImage: UIImageView!
    @IBOutlet weak var recommend_water_indecator: UIImageView!
    
    
    let headButton = UIButton()
    
    let helper = AlterChildInfoHelper.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.isScrollEnabled = false
        itemTableView.separatorColor = RGB_COLOR(255, g: 255, b: 255, alpha: 0.45)
        
        let view = UIView()
        view.backgroundColor = .white
        itemTableView.tableFooterView = view
        helper.deleteChildName = GChild.share.getActiveChildName()
        addTapGesture()
    }
    
    func addTapGesture() {
        
        let tapGet = UITapGestureRecognizer()
        tapGet.numberOfTapsRequired = 1
        recommendWaterLabel.isUserInteractionEnabled = true
        tapGet.addTarget(self, action: #selector(alterRecoTapAction))
        recommendWaterLabel.addGestureRecognizer(tapGet)
        
        let tapGet1 = UITapGestureRecognizer()
        tapGet1.numberOfTapsRequired = 1
        recommend_water_indecator.isUserInteractionEnabled = true
        tapGet1.addTarget(self, action: #selector(alterRecoTapAction))
        recommend_water_indecator.addGestureRecognizer(tapGet1)
        helper.deleteChildName = GChild.share.getActiveChildName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helper.loadChildInfoDataFromUserInfo()
        setViewDataFromUserInfo()
        itemTableView.reloadData()
        showDeleteButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headButton.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headButton.isHidden = true
    }
    
    func showDeleteButton() {
        if GUser.share.childList.count == 1 {
            deleteButton.isHidden = true
        }else{
            deleteButton.isHidden = false
        }
    }

    func setViewModel() {
        
        headButton.frame = CGRect(x: 50, y: 0, width: SCREEN_WIDTH-100, height: 40)
        headButton.titleLabel?.font = UIFont(name: BASEBOLDFONT,size: 22)
        headButton.setImage(UIImage(named: "setting_alter_name_button"), for: .normal)
        headButton.addTarget(self, action: #selector(nameClick(_:)), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(headButton)
        
        let tapGet = UITapGestureRecognizer()
        tapGet.numberOfTapsRequired = 1
        tapGet.addTarget(self, action: #selector(avatorClick(_:)))
        maskHeadImage.isUserInteractionEnabled = true
        maskHeadImage.addGestureRecognizer(tapGet)
        
        itemTableView.backgroundColor = .clear
    }
    
    func setViewDataFromUserInfo()  {
        headButton.setTitle(GChild.share.getActiveChildName(), for: .normal)
        
        headButton.setleftImage(5.0)
        
        let bgImage = UIImage(contentsOfFile: AvatorHelper.share.getImageFromDocumentPathURLWithID(activeChildID).path)
        if bgImage == nil {
            avatorImage.setBackgroundImage(UIImage(named: "avatar"), for: .normal)
        }else{
            avatorImage.setBackgroundImage(bgImage, for: .normal)
        }
        
        let unit = GChild.share.getChildUnitStr()
        let waterDay = GChild.share.getActiveChildRecommentWater(GUser.share.activeChild?.unit)

        recommendWaterLabel.text = String(format: Localizaed("%@'s daily water intake target:\r%d %@"),GChild.share.getActiveChildName(),waterDay,unit)
        
        setLabelAttributes("\(waterDay)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nameClick(_ sender: AnyObject) {
        gotoAlterDetailVC("NameVC")
    }
    
    @IBAction func avatorClick(_ sender: AnyObject) {
        gotoAlterDetailVC("photoSelVC")
    }
    
    func setLabelAttributes(_ waterDay:String) {
        let attributedString = NSMutableAttributedString(string: recommendWaterLabel.text!)
        let boardFout : UIFont = UIFont(name: BASEFONT,size: 38)!
        let boardfrontAttributes = [NSAttributedStringKey.font:boardFout]
        let frontStr = String(format: Localizaed("%@'s daily water intake target:"),GChild.share.getActiveChildName())
         attributedString.addAttributes(boardfrontAttributes, range: NSMakeRange(frontStr.count+1, waterDay.count))
        recommendWaterLabel.attributedText = attributedString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.childInfoData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemTableView.frame.size.height/3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "childInfoCell", for: indexPath) as! ChildInfoCell
        let item : InfoCell = helper.childInfoData[(indexPath as NSIndexPath).row]
        cell.itemImage.image = item.image
        cell.itemName.text = item.name
        cell.itemName.font = UIFont(name: BASEBOLDFONT,size: 22)
        cell.itemName.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            gotoAlterDetailVC("choseSexVC")
        case 1:
            gotoAlterDetailVC("birthdayVC")
        case 2:
            gotoAlterDetailVC("weightVC")
        default:
            return
        }
    }
    
    @objc func alterRecoTapAction() {
        gotoAlterDetailVC("recommandVC")
    }
    
    func gotoAlterDetailVC(_ vcName : String) {
        GUser.share.appStatus = .changeProfile
        goto(vcName: vcName, boardName: "Register")
    }
    
    @IBAction func deleteChild(_ sender: Any) {
                //do delete
        guard activeChildID != "" else {
            return
        }
        if GChild.share.childIsHaveCup() == true{
            showRemoveHaveBottle()
        }else{
            showRemoveNoBottleView()
        }
    }
    
    func showRemoveNoBottleView()  {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = String(format: Localizaed("Remove %@?"),GChild.share.getActiveChildName())
        let alertContent = String(format: Localizaed("Removing a child will erase the child's profile and data. Please be aware that this action CANNOT be restored."))
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Remove"))
        helper.alterViewTag = alter_no_bottle_view_tag
        alertView.delegate = self
        alertView.presentBHAlertView()
    }
    
    func showRemoveHaveBottle() {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = String(format: Localizaed("Remove %@?"),GChild.share.getActiveChildName())
        let alertContent = String(format: Localizaed("ATTENTION: %@ has a connected bottle. Removing %@ needs you to disconnect the bottle first."),GChild.share.getActiveChildName(),GChild.share.getActiveChildName())
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Disconnect"))
        helper.alterViewTag = alter_remove_have_bottle_tag
        alertView.delegate = self
        alertView.presentBHAlertView()
    }

    func rightButtonDelegateAction() {
        // delete child
        if helper.alterViewTag == alter_no_bottle_view_tag{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.showConfirmRemoveChildView()
            }
        }else if helper.alterViewTag == alter_confirm_remove_child_tag{
            deleteChildFromNet()
        }else if helper.alterViewTag == alter_remove_child_success_tag{
            removeChildSuccessAndBackToMain()
        }else if helper.alterViewTag == alter_remove_have_bottle_tag{
           unpairChildCup()
        }
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    
    func showConfirmRemoveChildView() {
        let alertView = BHAlertView(frame: view.frame)

        let alertTitle = String(format: Localizaed("Remove %@?"),GChild.share.getActiveChildName())
        let alertContent = String(format: Localizaed("You're about to remove %@ from your account. Please click confirm to proceed."),GChild.share.getActiveChildName())
        
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Confirm"))
        helper.alterViewTag = alter_confirm_remove_child_tag
        alertView.delegate = self
        alertView.presentBHAlertView()
    }
    
    func  unpairChildCup() {
        if !checkInternetConnection(){
            return
        }
        
        LoadingView().showLodingInView()
        GCup.share.unpairCup(activeChildID, cloudCallback: { result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    if result == true{
                        self.showConfirmRemoveChildView()
                    }else{
                        self.showDisconnectFailed()
                    }
                }
            }
        })
    }
    
    func deleteChildFromNet() {
        if !checkInternetConnection(){
            return
        }
        LoadingView().showLodingInView()
        GChild.share.deleteChildFromNet({ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    if result{
                        self.showRemoveChildSuccess()
                    }else{
                        self.showRemoveChildFailed()
                    }
                }
            }
        })

    }
    
    func saveHasCupIfRemoveFailed() {
        let child : Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return
        }
        child?.hasCup = 0
        saveContext()
    }
    
    func showRemoveChildSuccess() {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = Localizaed("Remove succeeded")
        let alertContent = String(format: Localizaed("%@ has been removed from your account."), helper.deleteChildName!)
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: "", rightBtnTitle:OK)
        helper.alterViewTag = alter_remove_child_success_tag
        alertView.delegate = self
        alertView.presentBHAlertView()
    }
    
    func removeChildSuccessAndBackToMain()  {
        GUser.share.appStatus = .deleteChild
        GUser.share.removeUserDefaultsID()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    func showRemoveChildFailed() {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = Localizaed("Remove failed")
        let alertContent = String(format: Localizaed("Unable to remove %@. Please try again later."), helper.deleteChildName!)
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: OK, rightBtnTitle:"")
        helper.alterViewTag = alter_remove_child_failed
        alertView.delegate = self
        alertView.presentBHAlertView()
        saveHasCupIfRemoveFailed()
    }
    
    func showDisconnectFailed()  {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = Localizaed("Disconnection failed")
        let alertContent = Localizaed("Unable to disconnect the bottle. Please try again later.")
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: OK, rightBtnTitle:"")
        helper.alterViewTag = alter_disconnect_cup_failed
        alertView.delegate = self
        alertView.presentBHAlertView()
    }
}
