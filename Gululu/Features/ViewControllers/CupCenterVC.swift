//
//  CupCenterVC.swift
//  Gululu
//
//  Created by Baker on 17/5/3.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class CupCenterVC: BaseViewController,BHAlertViewDelegate,UIScrollViewDelegate ,UIActionSheetDelegate{
    
    @IBOutlet weak var cupssidLabel: UILabel!
    @IBOutlet weak var connectwifiButton: UIButton!
    @IBOutlet weak var syncStatusButton: UIButton!
    
    let scroller = UIScrollView()
    let pageCon = UIPageControl()
    let deviceHelper = DeviceInfoHelper.share
    let cupinfoHelper = CupInfoHelper.share
    
    @IBOutlet weak var bigScrollerBottomCon: NSLayoutConstraint!
    @IBOutlet weak var connectWifiButtonWidthCon: NSLayoutConstraint!
    @IBOutlet weak var topCon: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setWifiStatusButtonStyle()
        addUnpairButtonInNaviBar()
        setViewValue()
        
        cupinfoHelper.saveClickRedSign(true)
        bigScrollerBottomCon.constant = FIT_SCREEN_WIDTH(-150)
        topCon.constant = FIT_SCREEN_HEIGHT(-135)
        connectwifiButton.adjustsImageWhenHighlighted = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        reloadDeviceInfo()
        addScrollerView()
        addPageControl()
        addVersionLabel()
    }
    
    func setViewValue() {
        if activeChildID == ""{
            return
        }
        cupssidLabel.text = GChild.share.getActiveChildName() + Localizaed("'s") + "\r" + "Gululu: " + GCup.share.readCupSSID(activeChildID)
    }
    
    func addUnpairButtonInNaviBar() {
        let uppairItem = UIBarButtonItem(image: UIImage(named: "moreButton"), style: .plain, target: self, action: #selector(showDissConectActionShet))
        navigationItem.rightBarButtonItem = uppairItem
    }
    
    func showRemoveHaveBottle() {
        let msgTitle = String(format: Localizaed("Disconnect bottle %@?"),GCup.share.readCupSSID(activeChildID))
        let detail = String(format:Localizaed( "After disconnection, you can connect the bottle with other child. But all the data and gaming progress will still be kept under %@'s profile"), GChild.share.getActiveChildName())
        let alertView = BHAlertView(frame:view.frame)
        alertView.initAlertContent(msgTitle, message: detail, leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Disconnect"))
        alertView.delegate = self
        cupinfoHelper.alterViewTag = cup_center_unpair_cup_tag
        alertView.presentBHAlertView()
    }
    
    @objc func showDissConectActionShet() {
        let msgTitle = String(format: Localizaed("Disconnect bottle %@?"),GCup.share.readCupSSID(activeChildID))
        let acVC : UIAlertController = UIAlertController(title: msgTitle, message: nil, preferredStyle: .actionSheet)
        acVC.addAction(UIAlertAction(title: CANCEL, style: .cancel, handler: nil))
        acVC.addAction(UIAlertAction(title: Localizaed("Disconnect"), style: .default, handler: { _ in
            self.showRemoveHaveBottle()
        }))
        self.present(acVC, animated: true, completion: nil)
    }
    
    func setWifiStatusButtonStyle() {
        connectwifiButton.setTitle(Localizaed("Change Wi-Fi settings"), for: .normal)
        let fitSize : CGSize = Common.getSizeFromString(connectwifiButton.currentTitle!, withFont: connectwifiButton.titleLabel?.font)
        connectWifiButtonWidthCon.constant = fitSize.width + 60
        connectwifiButton.layer.masksToBounds = true
        connectwifiButton.layer.cornerRadius = 25
        connectwifiButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
    }
    
    func reloadDeviceInfo() {
        
        checkNetIsNeedShowRedSign()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeNewSignObverserver), name: NSNotification.Name(rawValue:newSignObserverNotiStr), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeCupInfoObverserver), name: NSNotification.Name(rawValue:cupStatusNoticationName), object: nil)

        deviceHelper.checkAndGetChildDeviceInfo()

        cupinfoHelper.checkCupConnectStatues()
        
        addVersionLabel()
        
        setWifiStatusImage()
    }
    
    @objc func removeNewSignObverserver() {
        DispatchQueue.main.async {
            self.setScrollerConteOfSize()
            self.addVersionLabel()
            self.addPageControl()
            self.setScrollerViewState()
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: newSignObserverNotiStr), object: nil)
    }
    
    @objc func removeCupInfoObverserver() {
        DispatchQueue.main.async {
            self.setWifiStatusImage()
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: cupStatusNoticationName), object: nil)
    }
    
    func setWifiStatusImage() {
        if cupinfoHelper.cupConnectStatus {
            syncStatusButton.setImage(UIImage(named: "statusOk"), for: .normal)
        }else{
            syncStatusButton.setImage(UIImage(named: "statusWarning"), for: .normal)
        }
    }
    
    func addScrollerView() {
        if pageCon.currentPage == -1{
            scroller.backgroundColor = .clear
            scroller.isPagingEnabled = true
            scroller.showsVerticalScrollIndicator = false
            scroller.showsHorizontalScrollIndicator = false
            scroller.delegate = self
            scroller.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(deviceHelper.pageArray.count), height: 100)
            view.addSubview(scroller)
            scroller.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.bottom.equalTo(view).offset(0)
                ConstraintMaker.centerX.equalTo(view)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: FIT_SCREEN_HEIGHT(150)))
            }
        }
        setScrollerConteOfSize()
    }
    
    func setScrollerConteOfSize() {
        scroller.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(deviceHelper.pageArray.count), height: 100)
    }
    
    func addVersionLabel() {
        guard deviceHelper.pageArray.count != 0 else {
            return
        }
        
        for view : UIView in scroller.subviews{
            view.removeFromSuperview()
        }
        
        for i in 0...deviceHelper.pageArray.count-1{
            let versionItem : Version = deviceHelper.pageArray[i]
            let versionLabel = UILabel()
            versionLabel.font = UIFont(name: BASEFONT, size: 17)
            versionLabel.textColor = .white
            versionLabel.textAlignment = .center
            versionLabel.alpha = 0.8
            versionLabel.text = String(format : "%@: v%@",versionItem.package_name!,versionItem.package_verson!)
            scroller.addSubview(versionLabel)
            
            versionLabel.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.bottom.equalTo(scroller).offset(FIT_SCREEN_HEIGHT(70))
                ConstraintMaker.left.equalTo(scroller).offset(CGFloat(i)*SCREEN_WIDTH)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: FIT_SCREEN_HEIGHT(30)))
            }
            
            let versionButton = UIButton()
            versionButton.titleLabel?.textAlignment = .center
            versionButton.titleLabel?.textColor = .white
          
            versionButton.addTarget(self, action: #selector(showNoticeAlter), for: .touchUpInside)
            
            if deviceHelper.isNewVersion(versionItem){
                versionButton.setTitle(String(format : Localizaed("%@ is available"),versionItem.next_package!), for: .normal)
                setUpgradeButton(versionButton)
            }else{
                versionButton.setTitle(Localizaed("Latest version"), for: .normal)
                setLaststButton(versionButton)
            }
            scroller.addSubview(versionButton)
            let buttonWidth = Common.getLabWidth(labelStr: versionButton.currentTitle!, font: (versionButton.titleLabel?.font)!, height: 30)
            let buttonx = (SCREEN_WIDTH-buttonWidth-50)/2 + CGFloat(i)*SCREEN_WIDTH
            versionButton.snp.remakeConstraints { (ConstraintMaker) in
                ConstraintMaker.bottom.equalTo(scroller).offset(FIT_SCREEN_HEIGHT(100))
                ConstraintMaker.left.equalTo(scroller).offset(buttonx)
                ConstraintMaker.size.equalTo(CGSize(width: buttonWidth+50, height:FIT_SCREEN_HEIGHT(30)))
            }
            if deviceHelper.isNewVersion(versionItem){
                setUpgradeButtonImage(versionButton)
            }
        }
    }
    
    func setUpgradeButton(_ upgradeButton : UIButton) {
        upgradeButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 16)
        upgradeButton.titleLabel?.alpha = 1.0
        upgradeButton.isEnabled = true
        upgradeButton.setImage(UIImage(named: "updateHL"), for: .normal)
        upgradeButton.setImage(UIImage(named: "update"), for: .highlighted)
        upgradeButton.layer.masksToBounds = true
        upgradeButton.layer.cornerRadius = 15
        upgradeButton.backgroundColor = UIColor(red: (0.0/255.0), green: (0.0/255.0), blue: (0.0/255.0), alpha: 0.2)
    }
    
    func setUpgradeButtonImage(_ upgradeButton : UIButton) {
        upgradeButton.setleftImage(5.0)
    }
    
    func setLaststButton(_ upgradeButton : UIButton) {
        upgradeButton.titleLabel?.font = UIFont(name: BASEFONT, size: 16)
        upgradeButton.titleLabel?.alpha = 0.8
        upgradeButton.isEnabled = false
    }
    
    func addPageControl() {
        guard deviceHelper.pageArray.count > 1 else {
            return
        }
        if pageCon.currentPage == -1{
            pageCon.currentPageIndicatorTintColor = .white
            pageCon.pageIndicatorTintColor = RGB_COLOR(255, g: 255, b: 255, alpha: 0.3)
            view.addSubview(pageCon)
            pageCon.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.bottom.equalTo(view).offset(-20)
                ConstraintMaker.centerX.equalTo(view)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 5.0))
            }
        }
        pageCon.numberOfPages = deviceHelper.pageArray.count
    }
    
    // MARK: scrollerView delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page : Int = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        pageCon.currentPage = page
    }
    
    func setScrollerViewState() {
        pageCon.currentPage = deviceHelper.isFirstNewVersionAtPostion()
        scroller.scrollRectToVisible(CGRect(x: CGFloat(pageCon.currentPage)*SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: FIT_SCREEN_WIDTH(150)), animated: false)
    }
    
    @objc func showNoticeAlter(){
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let verifyCodeVC: SyncTimeAlterView = mainSB.instantiateViewController(withIdentifier: "syncTimeVC") as! SyncTimeAlterView
        verifyCodeVC.idSelf = self
        UIApplication.shared.keyWindow?.addSubview(verifyCodeVC.view)
        verifyCodeVC.oKButton.addTarget(self, action: #selector(removetest(_:)), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.moreStepLabel.text = Localizaed("How to upgrade?")
            verifyCodeVC.detailInfoLabel.text = Localizaed("Power on your Gululu,then keep it on the charger with Wi-Fi connected.Gululu will upgrade automactically!")
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.turnoverImage.isHidden = true
            verifyCodeVC.topImageView.image = UIImage(named: "upgradeSign")
        }
    }
    
    func showSyncView() -> Void {
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let verifyCodeVC: SyncTimeAlterView = mainSB.instantiateViewController(withIdentifier: "syncTimeVC") as! SyncTimeAlterView
        verifyCodeVC.idSelf = self
        view.addSubview(verifyCodeVC.view)
        verifyCodeVC.oKButton.addTarget(self, action: #selector(removeAlterView(_:)), for: .touchUpInside)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.turnoverImage.isHidden = true
            verifyCodeVC.topImageView.image = UIImage(named: "syncDone")
        }
    }
    
    @objc func removeAlterView(_ id:UIButton){
        for view :UIView in  view.subviews{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }
    
    // MAKR: BHdelgate
    func rightButtonDelegateAction() {
        if cupinfoHelper.alterViewTag == cup_center_unpair_cup_tag{
            unpairChildCup()
        }else if cupinfoHelper.alterViewTag == cup_center_show_sync_tag{
            if !checkInternetConnection(){
                return
            }
            LoadingView().showLodingInView()
            PairService.syncTimeZone({ ( bool ) in
                DispatchQueue.main.async {
                    LoadingView().stopAnimation()
                    if bool {
                        self.showSyncView()
                    }else{
                        self.showSyncFailed()
                    }
                }
            })
        }else{
            // no alter view
        }
    }
    
    func cancleButtonDelegateAction() {
        
    }
    
    func unpairChildCup() {
        if !checkInternetConnection(){
            return
        }
        
        LoadingView().showLodingInView()
        GCup.share.unpairCup(activeChildID, cloudCallback: { result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    if result == true{
                        self.removeChildCupAndBackToMain()
                    }else{
                        self.showDisconnectFailed()
                    }
                }
            }
        })
    }
    
    func removeChildCupAndBackToMain()  {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func removetest(_ id:UIButton){
        let window = UIApplication.shared.keyWindow?.subviews
        for view :UIView in  window!{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func showSyncStatus(_ sender: Any) {
        if cupinfoHelper.cupConnectStatus{
            showNormolSync()
        }else{
            showDelaySync()
        }
    }
    
    @IBAction func syncTime(_ sender: Any) {
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Confirm to synchronize the time of bottle to your phone clock?"), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Sync"))
        alertView.delegate = self
        cupinfoHelper.alterViewTag = cup_center_show_sync_tag
        alertView.presentBHAlertView()
    }
    
    @IBAction func gotoPairWifi(_ sender: Any) {
        connectwifiButton.alpha = 1.0
        GUser.share.appStatus = .changeWifi
        if !PairCupHelper.share.IsConnectValiedWiFi(){
            goto(vcName: "WifiStationConnect", boardName: "PairCup")
        }else{
            goto(vcName: "SSIDSetupVC", boardName: "PairCup")
        }
        
    }
    
    @IBAction func touchDownSetBG(_ sender: Any) {
        connectwifiButton.alpha = 0.5
    }
    
    @IBAction func dragOutsideBG(_ sender: Any) {
        connectwifiButton.alpha = 1.0
    }
    
    func showNormolSync() {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = String(format: Localizaed("Data synced: %@ ago"),cupinfoHelper.syncTime)
        let alertContent = String(format: Localizaed("Everything goes well. Data sync normally happens every 30 mins with Wi-Fi connected."))
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: "", rightBtnTitle: GOTIT)
        alertView.presentBHAlertView()
    }

    func showDelaySync() {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = String(format: Localizaed("Data synced: %@ ago"),cupinfoHelper.syncTime)
        let alertContent = String(format: Localizaed("To recover the connection, you can try:\n1. Power on your Gululu bottle and ensure a stable Wi-Fi connection.\n2. Click \"Change Wi-Fi settings\" to reset Wi-Fi.\n3. Contact us via customer-service@bowhead-tech.com."))
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: "", rightBtnTitle: GOTIT)
        alertView.presentBHAlertView()
    }
    
    func showDisconnectFailed()  {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = Localizaed("Disconnection failed")
        let alertContent = Localizaed("Unable to disconnect the bottle. Please try again later.")
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: OK, rightBtnTitle:"")
        alertView.presentBHAlertView()
    }
    
    func showSyncFailed()  {
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = Localizaed("Sync failed")
        let alertContent = Localizaed("Unable to disconnect the bottle. Please try again later.")
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: OK, rightBtnTitle:"")
        alertView.presentBHAlertView()
    }
    
}
