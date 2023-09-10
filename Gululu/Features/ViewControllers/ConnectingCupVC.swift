//
//  ConnectingCupVC.swift
//  Gululu
//
//  Created by Ray Xu on 8/01/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

enum PairStatus: Int {
    case pairReady = 0
    case pairDone
    case internetError
    case serviceError
    case routerError
    case rePairError
    case socketError
}

class ConnectingCupVC: BaseViewController, BHAlertViewDelegate {

    @IBOutlet weak var connectingImage: UIImageView!
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var connectingImgY: NSLayoutConstraint!

    @IBOutlet weak var finishBut: UIButton!
    @IBOutlet weak var waitingInd: UIActivityIndicatorView!
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var connectingWaiting: FLAnimatedImageView!
    @IBOutlet weak var imageFail: UIImageView!
    
    @IBOutlet weak var captionFail: UILabel!
    @IBOutlet weak var instructionFail: UILabel!
    @IBOutlet weak var connectingCenterY: NSLayoutConstraint!
    @IBOutlet weak var waitImage: UIImageView!
    @IBOutlet weak var abortButton: UIButton!

    let helper = PairCupHelper.share
    
    var pairStatus: PairStatus = .pairReady
    var ready2Main: Bool = false
    var connected : Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		initScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BHGululuLog().uploadLogFile(gululu_log_name)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)

        #if (arch(i386) || arch(x86_64)) && os(iOS)
			goto(vcName: "WelcomeVC", boardName: "PairCup")
			UIView.beginAnimations(nil, context: nil)
			UIView.setAnimationCurve(UIViewAnimationCurve.linear)
			UIView.setAnimationRepeatCount(12)
			UIView.setAnimationDuration(2)
			UIView.setAnimationDelay(1.0)
			
			let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
			connectingImage.transform = transform
			UIView.commitAnimations()
		#endif
		
        let thread = Foundation.Thread(target: self, selector: #selector(connectAP), object: nil)
        thread.start()
    }
    
    func initScreen() {
        navigationItem.hidesBackButton = true
        hideNavigation()
        
        let bundle = Bundle.main
        let URL = bundle.url(forResource: "waiting", withExtension: "gif")
        connectingLabel.text = Localizaed("Connecting to Gululu...")
        if connectingWaiting.animatedImage == nil {
            let data = try!  Data(contentsOf: URL!, options: NSData.ReadingOptions.mappedIfSafe)
            connectingWaiting.animatedImage = FLAnimatedImage(animatedGIFData:(data))
        }
        
        connectingWaiting.isHidden   = false
        connectingLabel.isHidden     = false
        cupImage.isHidden            = false
        phoneImage.isHidden          = false
        finishBut.isHidden           = true
        connectingImage.isHidden     = true
        captionFail.isHidden         = true
        instructionFail.isHidden     = true
        imageFail.isHidden           = true
        waitImage.isHidden           = true
        waitingInd.isHidden          = true
        abortButton.isHidden         = true
        waitingInd.startAnimating()
    }

    // MARK: - Connect Bottle AP
    @objc func connectAP(){
        let conn = TCPConnection()
        var cnt: Int = 0
        while !helper.isConnetGululuAP(){
            sleep(1)
            cnt += 1
            if cnt == 15 {
                conn.close()
                showErrorScreen(.socketError)
                return
            }
        }
        
        if helper.isConnetGululuAP() && connected == false{
            connected = true
            var bindType = "[Pair] ===================="
            if GUser.share.appStatus != .bindCup {
                bindType = "[Update] ===================="
            }
            BH_Log("Type: \(bindType)", logLevel: .pair)
            helper.resetAllGululuData()
            let pairStr = String(format:"Gululu ap: %@",helper.gululuSsid!)
            BH_Log(pairStr, logLevel: .pair)
            guard activeChildID != "" else {
                conn.close()
                BH_Log("ConnectingCupVC: child id nil need to check", logLevel: .error)
                return
            }
            
            let msgArray = helper.collectOrderArray()
            
            sleep(1)
            conn.connect("", messageArray: msgArray)
            
            sleep(1)
            if isValidString(helper.userSelectWifiPassword){
                let md5_str = String(format:"Password MD5 : %@",(helper.userSelectWifiPassword?.md5())!)
                BH_Log(md5_str, logLevel: .pair)
            }
            conn.sendMessage()
            
            sleep(1)
            conn.close()
        }
        
        confirmConnectionStatus(conn)
    }
    
    func confirmConnectionStatus(_ conn : TCPConnection) {
        var count = 0
        while (true) {
            count = count+1
            if count > 30 {
                conn.close()
                showErrorScreen(.socketError)
                break
            }
            sleep(2)
            if conn.statusComplete {
                connectRouter()
                break
            }
        }
    }
    
    // MARK: - Collect router
    @objc func connectRouter(){
        let connStatus = NetworkStatusNotifier()
        
        switch connStatus.connectionStatus() {
        case .unknown, .offline, .online(.wwan):
            NetworkStatusNotifier().monitorNetworkChanges()
        case .online(.wiFi):
            if !helper.isInternetWork() {
                showErrorScreen(.internetError)
                return
            }
        }
        if GUser.share.appStatus == .bindCup{
            reloadViewEnterRouter()
        }
        
        //wait IP address changes
        while helper.isConnetGululuAP(){

            sleep(1)
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                break
            #endif
        }
        
        if !helper.checkCloudAvalibility() {
            showErrorScreen(.serviceError)
            return
        }
		
        if GUser.share.appStatus == .changeWifi {
            reloadViewChangeWifi()
		} else {
            confirmPairComplete()
		}
    }

    fileprivate func confirmPairComplete() {
 
        if GUser.share.appStatus == .bindCup{
            self.reloadViewWhenPair()
        }
        
        var delaytime   = 0
        while !ready2Main {
            
            delaytime = delaytime + 1
            getChildCupList()
            
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                sleep(1)
            #else
                sleep(4)
            #endif
            if delaytime >= 5 {
                DispatchQueue.main.async{
                    self.connectingCenterY.constant = 24.0
                    self.connectingLabel.text = Localizaed("Still trying, may take\r\nup to 2 mins...")
                }
            }
            
            if delaytime >= 24 {
                helper.pairFailedLog()
                gotoTimeOut()
                return
            }
        }
        helper.pairOKLog()
        segueToMain()
    }
    
    func gotoTimeOut()  {
        DispatchQueue.main.async {
            let mainSB = UIStoryboard(name: "PairCup", bundle: nil)
            let timeOutVC = mainSB.instantiateViewController(withIdentifier: "ConnectTimeoutVC")
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            transition.type = kCATransitionMoveIn
            transition.subtype  = kCATransitionFromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(timeOutVC, animated: false)
        }
        
    }
	
	// MARK: Push to Next Page
    @objc func segueToNext() {
        if (GUser.share.appStatus != .changeWifi) {
            goto(vcName: "WelcomeVC", boardName: "PairCup")
        }
    }

    // MARK: Reload View
    func segueToMain() {
        DispatchQueue.main.async{
            self.connectingWaiting.isHidden   = true
            self.cupImage.isHidden            = true
            self.phoneImage.isHidden          = true
            self.waitImage.isHidden           = true
            self.waitingInd.isHidden          = true
            self.finishBut.isHidden           = true
            self.abortButton.isHidden         = true
            
            self.connectingImage.isHidden     = false
            self.connectingImage.image=UIImage(named: "connectSuccessful")
            
            self.connectingLabel.isHidden     = false
            self.connectingLabel.text = Localizaed("Successfully\r\nconnected!")
            self.connectingCenterY.constant = 0.0
            
            self.updateChildCupInfo()
            self.perform(#selector(ConnectingCupVC.segueToNext), with: nil, afterDelay: 1)
        }
    }
    
    func reloadViewEnterRouter() {
        DispatchQueue.main.async{
            self.connectingCenterY.constant = 24.0
            self.connectingWaiting.isHidden   = false
            self.cupImage.isHidden            = true
            self.phoneImage.isHidden          = true
            self.connectingImage.isHidden     = true
            self.captionFail.isHidden         = true
            self.instructionFail.isHidden     = true
            self.abortButton.isHidden         = true
            self.finishBut.isHidden           = true
            self.finishBut.setTitle("Retry", for: .normal)
            
            self.connectingLabel.isHidden     = false
            self.connectingLabel.text       = Localizaed("Confirming\r\nconnection result...")
            
            self.waitImage.isHidden           = false
            self.waitImage.image            = UIImage(named: "cloud")
        }
    }
    
    func reloadViewChangeWifi() {
        DispatchQueue.main.async{
            self.connectingCenterY.constant = 0.0
            self.connectingWaiting.isHidden   = true
            self.cupImage.isHidden            = true
            self.phoneImage.isHidden          = true
            self.finishBut.isHidden           = true
            self.waitImage.isHidden           = true
            self.waitingInd.isHidden          = true
            self.abortButton.isHidden         = true
            
            self.connectingImage.isHidden     = false
            self.connectingLabel.isHidden     = false
            self.connectingLabel.text       = Localizaed("The Wi-Fi passwords have been sent successfully,\rPlease check the setting result on your Gululu.")
            self.finishBut.isHidden           = false
            self.finishBut.setTitle(Localizaed("Finish"), for: .normal)
            
            self.helper.updateOKLog()
            self.pairStatus = .pairDone
        }
    }
    
    func reloadViewWhenPair() {
        DispatchQueue.main.async{
            self.connectingCenterY.constant = 24.0
            self.cupImage.isHidden            = true
            self.phoneImage.isHidden          = true
            self.connectingImage.isHidden     = true
            self.captionFail.isHidden         = true
            self.instructionFail.isHidden     = true
            self.finishBut.isHidden           = true
            self.abortButton.isHidden         = true
            
            self.connectingWaiting.isHidden   = false
            self.waitImage.isHidden           = false
            self.waitImage.image            = UIImage(named: "cloud")
            
            self.connectingLabel.isHidden     = false
            self.connectingLabel.text       = Localizaed("Confirming\r\nconnection result...")
        }
    }
    
    func showErrorScreen(_ error: PairStatus) {
        if GUser.share.appStatus == .bindCup{
            helper.pairFailedLog()
        }else{
            helper.updateFialedLog()
        }

        DispatchQueue.main.async{
            self.connectingWaiting.isHidden   = true
            self.connectingLabel.isHidden     = true
            self.cupImage.isHidden            = true
            self.phoneImage.isHidden          = true
            self.connectingImage.isHidden     = true
            self.waitImage.isHidden           = true
            
            self.captionFail.isHidden         = false
            self.instructionFail.isHidden     = false
            self.imageFail.isHidden           = false
            self.abortButton.isHidden         = false
            self.imageFail.contentScaleFactor = 0.5
            
            let errorInfo = self.getPairErrorInformation(error)
            self.captionFail.text = errorInfo.errTitle
            self.instructionFail.text = errorInfo.errSolution
            self.imageFail.image = UIImage(named: errorInfo.errImage)
            
            self.finishBut.isHidden = false
            switch error {
            case .routerError:  self.finishBut.setTitle("Check", for: .normal)
            default:            self.finishBut.setTitle("Retry", for: .normal)
            }
        }
        self.pairStatus = error
    }
    
    fileprivate func getPairErrorInformation(_ status: PairStatus) -> (errImage: String, errTitle: String, errSolution: String) {
        var errImage: String = ""
        var errTitle: String = ""
        var errSolution: String = ""
        
        switch status {
        case .internetError:
            errImage = "conFail"
            errTitle = Localizaed("Connection failed :(")
            errSolution = Localizaed("Please double check your internet connection and try again.")
            
        case .serviceError:
            errImage = "ServiceError"
            errTitle = Localizaed("Oops, service error occured :(")
            errSolution = Localizaed("We’re trying to fix it ASAP. Please come back later and try again.")
            
        case .routerError:
            errImage = "connectionFailed"
            errTitle = Localizaed("Connection failed :(")
            errSolution = Localizaed("Please double check the wifi name and password you entered, and make sure the wifi connection is stable.")
            
        case .rePairError:
            errImage = "occupied"
            errTitle = Localizaed("This Gululu is occupied :(")
            errSolution = Localizaed("Each bottle can only be connected to one account. Please select another one and try again.")
            
        case .socketError:
            errImage = "connectionLost"
            errTitle = Localizaed("Connection Lost :(")
            errSolution = Localizaed("Please make sure your Gululu is on the ID screen and close to your mobile device.")
            
        default:
            errImage = "conFail"
            errTitle = Localizaed("Connection failed :(")
            errSolution = Localizaed("Please double check your internet connection and try again.")
        }
        
        return (errImage, errTitle, errSolution)
    }
    
    // MARK: Pop to Setting View with Segue
    @IBAction func segueToSetting(_ sender: AnyObject) {
        switch pairStatus {
        case .pairDone:
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: SettingsVC.self) || controller.isKind(of: MainVC.self) {
                    _ = navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
            
        case .routerError:
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: SSIDSetupVC.self) {
                    _ = navigationController?.popToViewController(controller as UIViewController, animated: true)
                    break
                }
            }
            
        case .socketError:
            for aViewController in navigationController!.viewControllers {
                if (aViewController is ConectingVerfyVC) {
                    _ = navigationController!.popToViewController(aViewController, animated: true)
                }
            }
            
        case .internetError, .serviceError:
            initScreen()
            let retryThread = Foundation.Thread(target: self, selector: #selector(ConnectingCupVC.connectRouter), object: nil)
            retryThread.start()
            
        default:
            initScreen()
            let thread = Foundation.Thread(target: self, selector: #selector(ConnectingCupVC.connectAP), object: nil)
            thread.start()
        }
        pairStatus = .pairDone
    }
    
    // MARK: Show Abort Alter
    @IBAction func abortConnectAction(_ sender: AnyObject) {
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.delegate = self
        alertView.initAlertContent(Localizaed("Abort connecting?"), message: Localizaed("Without connection to Gululu, your child’s water drinking behavior won’t be recorded. You can still do it in the app sometime later."), leftBtnTitle: CANCEL, rightBtnTitle: Localizaed("Abort"))
        alertView.presentBHAlertView()
    }
    
    func cancleButtonDelegateAction() {
        //
    }
    
    // MARK: - BHAlertView Delegate
    func rightButtonDelegateAction() {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = navigationController?.viewControllers[0]
        
        if rootVC!.isKind(of: MainVC.self) {
            _ = navigationController?.popToRootViewController(animated: true)
        } else {
            let mainVC: MainVC = mainSB.instantiateViewController(withIdentifier: "showMainVC") as! MainVC
            mainVC.helper.childrenDisplayed = true
            navigationController?.pushViewController(mainVC, animated: true)
        }
    }
}

extension ConnectingCupVC {
    
    func getChildCupList() {
        checkNetIsNeedShowRedSign()
        GCup.share.getChildCupList({ result in
            if result{
                self.ready2Main = true
            }
        })
    }
    
    func updateChildCupInfo() {
        checkNetIsNeedShowRedSign()
        GCup.share.updateChildCupInfo({ result in
            if result == false {
                DispatchQueue.main.async {
                    let alertView = BHAlertView(frame: BASE_FRAME)
                    alertView.initAlertContent("", message: Localizaed("Update child data failed"), leftBtnTitle: DONE, rightBtnTitle: "")
                    alertView.presentBHAlertView()
                }
            }
        })
    }
    
}
