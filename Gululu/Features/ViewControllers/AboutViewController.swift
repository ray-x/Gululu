//
//  AboutViewController.swift
//  Gululu
//
//  Created by Wei on 6/9/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit
////import Flurry_iOS_SDK

enum WebType: Int {
    case facebook   = 0
    case twitter
    case instagram
    case pinterest
    case aboutUs
    case terms
    case policy
    case weibo
    case weixin
    case contantUs
}

struct ButtonItem {
    var buttonImage : UIImage
    var buttonTag : Int
    init (_ buttonImage:String,buttonTag:Int){
        self.buttonImage = UIImage(named: buttonImage)!
        self.buttonTag = buttonTag
    }
}

class AboutViewController: BaseViewController,BHAlertViewDelegate,UIScrollViewDelegate
{
    var buttonData = [ButtonItem]()
    let versionHelper = GVersion.share
    let deviceHelper = DeviceInfoHelper.share
    
    let scroller = UIScrollView()
    let pageCon = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        layoutAboutView()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        reloadDeviceInfo()
        addScrollerView()
        //addPageControl()
        addVersionLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setScrollerViewState()
    }
    func loadData() {
        if Common.checkPreferredLanguages() == 1{
            let buttonItem1 = ButtonItem("weixin", buttonTag:WebType.weixin.rawValue)
            let buttonItem2 = ButtonItem("weibo", buttonTag:WebType.weibo.rawValue)
            buttonData = [buttonItem1,buttonItem2]
        }else{
            let buttonItem1 = ButtonItem("facebookF", buttonTag:WebType.facebook.rawValue)
            let buttonItem2 = ButtonItem("twitterF", buttonTag:WebType.twitter.rawValue)
            let buttonItem3 = ButtonItem("instagramF", buttonTag:WebType.instagram.rawValue)
            let buttonItem4 = ButtonItem("pinterestF", buttonTag:WebType.pinterest.rawValue)
            buttonData = [buttonItem1,buttonItem2,buttonItem3,buttonItem4]
        }
    }
    
    func reloadDeviceInfo() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeNewSignObverserver), name: NSNotification.Name(rawValue: newSignObserverNotiStr), object: nil)
        
        DeviceInfoHelper.share.setPageArrayWhenitHaveOnlyAPP()
        
        addVersionLabel()
    }

    @objc func removeNewSignObverserver() {
        DispatchQueue.main.async {
            self.addVersionLabel()
            self.setScrollerViewState()
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: newSignObserverNotiStr), object: nil)
    }
    
    
    func layoutAboutView() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "settingBack")
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
        
        let logoImage = UIImage(named: "shapeU")
        let logoImageView = UIImageView()
        logoImageView.image = logoImage
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(view)
            ConstraintMaker.centerY.equalTo(view).dividedBy(3.15)
            ConstraintMaker.size.equalTo(CGSize(width: (logoImage?.size.width)!, height: (logoImage?.size.height)!))
        }
        addButtonInView()

        let buttonSize: CGSize = CGSize(width: FIT_SCREEN_WIDTH(206), height: FIT_SCREEN_HEIGHT(50))
        let aboutusButton = UIButton(type: .custom)
        aboutusButton.setTitle(Localizaed("About Gululu"), for: .normal)
        aboutusButton.setTitleColor(.white, for: .normal)
        aboutusButton.titleLabel?.font = UIFont(name: BASEFONT, size: 22.0)
        aboutusButton.layer.masksToBounds = true
        aboutusButton.layer.cornerRadius = buttonSize.height/2
        aboutusButton.tag = WebType.aboutUs.hashValue
        aboutusButton.addTarget(self, action: #selector(actionToWebPage(_:)), for: .touchUpInside)
        aboutusButton.addTarget(self, action: #selector(touchDownAction(_:)), for: .touchDown)
        aboutusButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        view.addSubview(aboutusButton)
        aboutusButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(view)
            ConstraintMaker.centerY.equalTo(view).dividedBy(0.85)
            ConstraintMaker.size.equalTo(buttonSize)
        }
        
        let policysButton = UIButton(type: .custom)
        policysButton.setTitle(Localizaed("Privacy Policy"), for: .normal)
        policysButton.setTitleColor(.white, for: .normal)
        policysButton.titleLabel?.font = UIFont(name: BASEFONT, size: 22.0)
        policysButton.layer.masksToBounds = true
        policysButton.layer.cornerRadius = buttonSize.height/2
        policysButton.tag = WebType.policy.hashValue
        policysButton.addTarget(self, action: #selector(actionToWebPage(_:)), for: .touchUpInside)
        policysButton.addTarget(self, action: #selector(touchDownAction(_:)), for: .touchDown)
        policysButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)

        view.addSubview(policysButton)
        policysButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(view)
            ConstraintMaker.centerY.equalTo(view).dividedBy(0.75)
            ConstraintMaker.size.equalTo(buttonSize)
        }
        
        let contantUsButton = UIButton(type: .custom)
        contantUsButton.setTitle(Localizaed("Contact Us"), for: .normal)
        contantUsButton.setTitleColor(.white, for: .normal)
        contantUsButton.titleLabel?.font = UIFont(name: BASEFONT, size: 22.0)
        contantUsButton.layer.masksToBounds = true
        contantUsButton.layer.cornerRadius = buttonSize.height/2
        contantUsButton.tag = WebType.contantUs.hashValue
        contantUsButton.addTarget(self, action: #selector(actionToWebPage(_:)), for: .touchUpInside)
        contantUsButton.addTarget(self, action: #selector(touchDownAction(_:)), for: .touchDown)
        contantUsButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        
        view.addSubview(contantUsButton)
        contantUsButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(view)
            ConstraintMaker.centerY.equalTo(view).dividedBy(0.68)
            ConstraintMaker.size.equalTo(buttonSize)
        }
        
    }
    
    func addButtonInView() {
        let imageWidth = SCREEN_WIDTH/7.5
        let middle = SCREEN_WIDTH/15
        let middleandbutton = imageWidth + middle
        for i in 0..<buttonData.count{
            let buttonItem = buttonData[i]
            let allButtonwidth = CGFloat(buttonData.count)*middleandbutton
            let lage = SCREEN_WIDTH + CGFloat(middle)
            let buttonx1 = CGFloat(i)*middleandbutton
            let buttonx = buttonx1 + (lage - allButtonwidth)/2
            let buttony = SCREEN_HEIGHT/2.65
            let customButton = UIButton(frame: CGRect(x: buttonx, y: buttony, width: imageWidth, height: imageWidth))
            customButton.setBackgroundImage(buttonItem.buttonImage, for: .normal)
            customButton.adjustsImageWhenHighlighted = false
            customButton.alpha = 0.75
            customButton.layer.masksToBounds = true
            customButton.layer.cornerRadius = imageWidth/2
            customButton.tag = buttonItem.buttonTag
            customButton.addTarget(self, action: #selector(actionToWebPage(_:)), for: .touchUpInside)
            customButton.addTarget(self, action: #selector(butonIn(_:)), for: .touchDown)
            customButton.addTarget(self, action: #selector(butonOut(_:)), for: .touchUpOutside)

            view.addSubview(customButton)
        }
    }
    
    @objc func butonIn(_ button : UIButton) {
        button.alpha = 1.0
    }
    
    @objc func butonOut(_ button : UIButton) {
        button.alpha = 0.75
    }
    
    @objc func actionToWebPage(_ button: UIButton){
        button.alpha = 0.75

        var webURL: String = ""
        var logName : String = "sns_click_"
        switch button.tag {
        case WebType.facebook.rawValue:
            webURL = facebook_web_utl
            logName = logName + "facebook"
            break
        case WebType.twitter.rawValue:
            webURL = twitter_web_url
            logName = logName + "twitter"
            break
        case WebType.instagram.rawValue:
            webURL = instagram_web_url
            logName = logName + "instagram"
            break
        case WebType.pinterest.rawValue:
            webURL = pinterest_web_url
            logName = logName + "pinterest"
            break
        case WebType.aboutUs.rawValue:
            button.backgroundColor = .clear
            button.titleLabel?.alpha = 1.0
            webURL = about_web_url
            break
        case WebType.terms.rawValue:
            webURL = ter_servece_web_url
            break
        case WebType.policy.rawValue:
            button.backgroundColor = .clear
            button.titleLabel?.alpha = 1.0
            webURL = privacy_web_url
            break
        case WebType.weixin.rawValue:
            handleWeixinAlter()
            logName = logName + "wechat"
            break
        case WebType.weibo.rawValue:
            webURL = weibo_web_url
            logName = logName + "weibo"
            break
        case WebType.contantUs.rawValue:
            button.backgroundColor = .clear
            button.titleLabel?.alpha = 1.0
            webURL = AboutHelper.share.getContantUsUrl()
            break
        default:
            webURL = gululu_web_url
        }
        
        if logName != "sns_click_"{
            //Flurry.logEvent(logName)
        }
        
        if webURL != ""{
            let broswerView = BrowserViewController()
            broswerView.webURL = webURL
            present(broswerView, animated: true, completion: nil)
        }
    }
    
    func handleWeixinAlter() {
        
        let pasteboard : UIPasteboard = UIPasteboard.general
        
        pasteboard.string = "Gululu水精灵"
        
        guard let url = URL(string: "wechat://") else { return }
        
        guard UIApplication.shared.canOpenURL(url) else {
            let alertView = BHAlertView(frame: view.frame)
            let alertTitle = ""
            let alertContent = "尚未安装微信，请先安装微信，然后搜索“Gululu水精灵”并关注我们。"
            alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: "好的", rightBtnTitle:"")
            alertView.delegate = self
            alertView.presentBHAlertView()
            return
        }
        
        let alertView = BHAlertView(frame: view.frame)
        let alertTitle = "关注微信公众号"
        let alertContent = "已将微信公众号“Gululu水精灵”复制到剪贴板，请在微信搜索中点击“公众号”，然后搜索并关注我们。"
        alertView.initAlertContent(alertTitle, message: alertContent, leftBtnTitle: "取消", rightBtnTitle:"去关注")
        alertView.delegate = self
        alertView.presentBHAlertView()

    }

    // MAKR: BHdelgate
    func rightButtonDelegateAction() {
        // delete child
        UIApplication.shared.openURL(NSURL(string: "wechat://")! as URL)
        //Flurry.logEvent("sns_click_wechat_open")
    }
    
    func cancleButtonDelegateAction() {
        //
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
            
            if versionItem.package_name == deviceHelper.appVersionName {
                versionButton.addTarget(self, action: #selector(goToAppStore), for: .touchUpInside)
            }else{
                versionButton.addTarget(self, action: #selector(showNoticeAlter), for: .touchUpInside)
            }
            
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
        upgradeButton.backgroundColor = RGB_COLOR(0.0, g: 0.0, b: 0.0, alpha: 0.2)
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
    
    @objc func removetest(_ id:UIButton){
        let window = UIApplication.shared.keyWindow?.subviews
        for view :UIView in  window!{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: Events of upgradeButton
    @objc func goToAppStore() {
    
        let url = URL(string: apple_store_url)!
        UIApplication.shared.openURL(url)
    }
    
    @objc func touchDownAction(_ button: UIButton)  {
        button.backgroundColor = RGB_COLOR(0, g: 0, b: 0, alpha: 0.15)
        button.titleLabel?.alpha = 0.8
    }
    
    @objc func touchDragOutsideAction(_ button: UIButton) {
        button.backgroundColor = .clear
        button.titleLabel?.alpha = 1.0
    }
}
