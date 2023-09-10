//
//  PowerOnVC.swift
//  Gululu
//
//  Created by Ray Xu on 4/06/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit
import NetworkExtension


class ConectingVerfyVC: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var pairScrollView: UIScrollView!
    @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pairDetailLabel: InsetLabel!
    @IBOutlet weak var title_animation_view: UIView!
    @IBOutlet weak var iOS10Label: InsetLabel!
    
    
    var ssidTextFeild : UITextField?
    let helper = PairCupHelper.share
    var titlt_animation:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutScrollView()
        NotificationCenter.default.addObserver(self, selector: #selector(appToForground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        nextButton.setTitle(NEXT, for: .normal)
        set_page_control_color()
        set_corner_pair_detail_label()
        setPairtitlelabelHeight(0)
        iOS10Label.isHidden = true;
    }
    
    func set_page_control_color() {
        pageControlView.currentPageIndicatorTintColor = RGB_COLOR(5, g: 174, b: 227, alpha: 1.0)
        pageControlView.pageIndicatorTintColor = RGB_COLOR(190, g: 190, b: 190, alpha: 1.0)
    }
    
    func set_corner_pair_detail_label() {
        pairDetailLabel.layer.masksToBounds = true
        pairDetailLabel.layer.cornerRadius = 4.0
    }
    
    func setPairtitlelabelHeight(_ page : Int) {
        let laberText = helper.getPairDetailInfoFromPage(page)
        pairDetailLabel.text = laberText
        pairDetailLabel.paddingTop = 3
        pairDetailLabel.paddingBottom = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
        pairScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    func layoutScrollView() {
        let pageNums: Int = pageControlView.numberOfPages
        pairScrollView.contentSize = CGSize(width: SCREEN_WIDTH*CGFloat(pageNums), height: 0.0)
        pairScrollView.delegate = self
        
        for i in 0 ... pageNums-1 {
            let rect = CGRect(x: SCREEN_WIDTH*CGFloat(i), y: 0.0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*7/6.4)

            if i == pageNums-1{
                if helper.iOS11Later()
                {
                    setIOS11LaterPageView(i)
                }else{
                    setIOS10LastPageView(i, rect: rect)
                }
            }else{
                let pairTipImage = FLAnimatedImageView()
                pairTipImage.frame = rect
                let petFile = helper.getPairScrollerImageArray()[i]
                let URLPet = Bundle.main.url(forResource: petFile, withExtension: "gif")
                if URLPet != nil{
                    let dataPet = try? Data(contentsOf: URLPet!, options: NSData.ReadingOptions.mappedIfSafe)
                    pairTipImage.animatedImage = FLAnimatedImage(animatedGIFData:(dataPet))
                    pairScrollView.addSubview(pairTipImage)
                }
            }
        }
    }

    func setIOS11LaterPageView(_ i: Int) {
        let image_SSID =  UIImage(named: "Connect_ssid_image")
        let imageRect = CGRect(x: SCREEN_WIDTH*CGFloat(i) + (SCREEN_WIDTH - (image_SSID?.size.width)!)/2, y: 0, width: (image_SSID?.size.width)!, height: (image_SSID?.size.height)!)
        let iOS11TipsImage = UIImageView(frame: imageRect)
        iOS11TipsImage.image = image_SSID
        pairScrollView.addSubview(iOS11TipsImage)
        
        let rect = CGRect(x: SCREEN_WIDTH*CGFloat(i) + SCREEN_WIDTH/2-93.75, y: (image_SSID?.size.height)! + 15, width: 187.5, height: 60)
        let inputView = UIView(frame: rect)
        inputView.layer.masksToBounds = true
        inputView.layer.cornerRadius = 5.0
        inputView.layer.borderWidth = 2.0
        inputView.layer.borderColor = RGB_COLOR(48, g: 179, b: 226, alpha: 1).cgColor
        pairScrollView.addSubview(inputView);
        
        let ULableFrame = CGRect(x:10, y:0, width: 30, height: 60)
        let ULable = UILabel(frame: ULableFrame)
        ULable.text = "U"
        ULable.textAlignment = .right
        ULable.font = UIFont(name: BASEFONT, size: 40)
        inputView.addSubview(ULable)
        
        let rect1 = CGRect(x: 40, y: 0, width: 147.5, height: 60)
        ssidTextFeild = UITextField(frame: rect1)
        ssidTextFeild?.placeholder = "0000"
        ssidTextFeild?.delegate = self
        ssidTextFeild?.returnKeyType = .join
        ssidTextFeild?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        ssidTextFeild?.font = UIFont(name: BASEFONT, size: 40)
        inputView.addSubview(ssidTextFeild!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "")
        {
            return true
        }else{
            if(textField.text?.count == 4){
                return false
            }
            return true
        }
    }
    
    @objc func textFieldDidChange()
    {
        if(ssidTextFeild?.text?.count == 4){
            nextButton.isEnabled = true
        }else if(ssidTextFeild?.text?.count > 4){
            let textSSID : NSString = NSString(string: (ssidTextFeild?.text)!)
            ssidTextFeild?.text = textSSID.substring(with: NSRange(location: 0, length: 4))
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false

        }
        
        ssidTextFeild?.text = ssidTextFeild?.text?.uppercased()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(ssidTextFeild?.text?.count == 4){
            connectGululuSSID()
            ssidTextFeild?.resignFirstResponder()
            return true
        }else{
            return false
        }
    }
    
    func setIOS10LastPageView(_ i: Int, rect: CGRect) {
        let rect = CGRect(x: SCREEN_WIDTH*CGFloat(i), y: 0.0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*7/6.4)

        let pairTipImage = UIImageView()
        pairTipImage.image = UIImage(named: helper.getPairScrollerImageArray()[i])
        pairTipImage.frame = rect
        pairScrollView.addSubview(pairTipImage)
    }
    
    
    @objc func appToForground() {
        if pageControlView.currentPage == pageControlView.numberOfPages-1 {
            helper.setChooseAP(false)
            if PairCupHelper.share.isConnetGululuAP() {
                sleep(1)
                goto(vcName: "connectingCup", boardName: "PairCup")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screen_wigth_x = Int(SCREEN_WIDTH)
        let pageX: Int = Int(scrollView.contentOffset.x)
        let page_1 = pageControlView.currentPage
        self.title_animation_view.transform = CGAffineTransform.identity
        
        var move_x = pageX - (page_1*screen_wigth_x)
        if move_x < 0{
            move_x = -move_x
        }
        let move_rate = Float(move_x)/Float(screen_wigth_x)

        if move_rate <= 0.5{
            self.title_animation_view.transform = self.title_animation_view.transform.scaledBy(x: CGFloat(1-move_rate), y: CGFloat(1-move_rate))
            self.title_animation_view.alpha = CGFloat(1-move_rate*2)
        }else{
            self.title_animation_view.alpha = 0
        }
    }
    
    func animaition_big_when_scroller(_ page: Int) {
        if titlt_animation == false{
            self.setPairtitlelabelHeight(page)
            self.title_animation_view.alpha = 1.0
            self.title_animation_view.transform = self.title_animation_view.transform.scaledBy(x: 0.5, y: 0.5)
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 15, options: .curveEaseIn, animations: {
                self.title_animation_view.transform = self.title_animation_view.transform.scaledBy(x: 2.0, y: 2.0)
            }) { (finish) in
                self.titlt_animation = false
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewW: CGFloat = pairScrollView.frame.width
        let pageX: CGFloat = pairScrollView.contentOffset.x
        let page: Int = Int((pageX + scrollViewW/2) / scrollViewW)
        pageControlView.currentPage = page
        setViewWhenScrollerViewEnd()
    }
    
    func setViewWhenScrollerViewEnd() {
        animaition_big_when_scroller(pageControlView.currentPage)
        if pageControlView.currentPage == pageControlView.numberOfPages-1 {
            relayoutDependOnIfiOS10()
        } else {
            ssidTextFeild?.resignFirstResponder()

            nextButton.isEnabled = true
            nextButton.setTitle(NEXT, for: .normal)
            nextButton.setBackgroundImage(UIImage(named: "buttonNormal"), for: .normal)
        }
    }
    
    func relayoutDependOnIfiOS10() {
        if helper.iOS11Later()
        {
            iOS10Label.isHidden = true
            nextButton.setTitle(Localizaed("Connect"), for: .normal)
            nextButton.isEnabled = false
            ssidTextFeild?.becomeFirstResponder()
        }else{
            iOS10Label.isHidden = false
            iOS10Label.text = Localizaed("Pair_iOS10_tips")
            nextButton.isHidden = true
            helper.setChooseAP(true)
//            nextButton.setTitle(Localizaed("Setting"), for: .normal)
        }
        nextButton.setBackgroundImage(UIImage(named: "buttonNormal"), for: .normal)
    }
    // MARK: Next button action
    @IBAction func nextButtonAction(_ sender: AnyObject) {
        if pageControlView.currentPage != pageControlView.numberOfPages-1 {
            pageControlView.currentPage = pageControlView.currentPage + 1
            let scrollViewX = CGFloat(pageControlView.currentPage) * pairScrollView.frame.width
            pairScrollView.setContentOffset(CGPoint(x: scrollViewX, y: 0.0), animated: true)
            setViewWhenScrollerViewEnd()
        } else {
            if !helper.isConnetGululuAP(){
                if helper.iOS11Later()
                {
                    connectGululuSSID()
                }else{
                    helper.setChooseAP(true)
                }
            }else{
                gotoConnectView()
            }
        }
    }
    
    func connectGululuSSID() {
        if ssidTextFeild?.text?.count != 4{
            return
        }
        
        LoadingView().showLodingInView()
        if #available(iOS 11.0, *) {
            let hostCOnfig = NEHotspotConfiguration(ssid: "U" + (ssidTextFeild?.text)!)
            NEHotspotConfigurationManager.shared.apply(hostCOnfig, completionHandler: { (error) in
                DispatchQueue.main.async {
                    if(error != nil){
                        LoadingView().stopAnimation()
                        return
                    }
                    if self.helper.isConnetGululuAP()
                    {
                        self.gotoConnectView()
                    }else{
                        self.setTheTimer()
                    }
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setTheTimer() {
        if helper.connect_cup_timer != nil{
            deinitTimer()
        }
        helper.connect_cup_timer = DispatchSource.makeTimerSource(queue: .main)
        helper.connect_cup_timer?.schedule(deadline: .now(), repeating: LoginHelper.share.oneStepTime)
        helper.connect_cup_timer?.setEventHandler {
            if self.helper.isConnetGululuAP()
            {
                self.gotoConnectView()
            }else{
                self.helper.verify_connect_time = self.helper.verify_connect_time - 1
                if self.helper.verify_connect_time <= 0
                {
                    self.showConnectFaied()
                    self.deinitTimer()
                }
            }
        }
        // 启动定时器
        helper.connect_cup_timer?.resume()
    }
    
    func deinitTimer() {
        LoadingView().stopAnimation()
        helper.deinitTimer()
    }
    
    func gotoConnectView()  {
        deinitTimer()
        goto(vcName: "connectingCup", boardName: "PairCup")
    }
    
    func showConnectFaied()  {
        LoadingView().stopAnimation()

        let alertView = BHAlertView(frame: self.view.frame)
        alertView.initAlertContent("", message:  Localizaed("Didn't find your Gululu. Please check the ID and keep your Gululu shows the ID screen."), leftBtnTitle: "", rightBtnTitle: OK)
        alertView.presentBHAlertView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
}
