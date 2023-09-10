//
//  AppDelegate.swift
//  Gululu
//
//  Created by Ray Xu on 26/10/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import CoreData

//import Fabric
//import Crashlytics
//import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate,BHAlertViewDelegate, UNUserNotificationCenterDelegate
{
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
    
    var window: UIWindow?

    var startNavigationController  = UIViewController()
    let nav1 = UINavigationController()
    let helper = AppDelegateHelper.share

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        print(managedObjectContext)
        catch_crash_myself()
        let dir = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print(dir)
        window = UIWindow(frame: UIScreen.main.bounds)
        nav1.navigationBar.barTintColor = RGB_COLOR(0, g: 174, b: 228, alpha: 0.1)
        nav1.navigationBar.tintColor = UIColor(red: 0.0, green: 174.0/255.0, blue: 228.0/255.0, alpha: 0.1)
        nav1.navigationBar.isTranslucent = true
        nav1.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont(name: BASEBOLDFONT,size: 22) as Any, NSAttributedStringKey.foregroundColor:UIColor.white]
        nav1.navigationBar.shadowImage = UIImage()
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.tintColor = .white
        nav1.setNavigationBarHidden(true, animated: false)
        
        setHelpUnitInfo(application, launchOptions: launchOptions)
        
        GUserConfigUtil.share.checkout_health_in_feature_config{_ in}
//        let dateStr = BKDateTime.getLocalDateString()
//        print(dateStr)
        GUser.share.showloginEntrance({ result in
            switch result {
            case 0:
                self.gotoLogin()
                break
            case 1:
                self.gotoMainVC()
                break
            case 2:
                self.gotoLogin()
                break
            default:
                self.gotoLogin()
                break
            }
        })
        
        window?.makeKeyAndVisible()
		
        return true
    }
    
    func catch_crash_myself() {
        crashHandle { (crashInfoArr) in
            if crashInfoArr.count == 0{
                return
            }
            for info in crashInfoArr{
                BH_ERROR_LOG(info)
            }
        }
    }
    
    func setUserNotifacation(_ application : UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = 0|1|2
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            
            let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (result, error) in
                if result{
                    print("notication success")
                }else{
                    print("notication error")
                }
            })
            
        }else{
            //ios 8 - ios 9
            let notificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            
            JPUSHService.register(forRemoteNotificationTypes: 0|1|2, categories: nil)
        }
        application.registerForRemoteNotifications()
        
        JPUSHService.setup(withOption: launchOptions, appKey: jpushKey, channel: nil, apsForProduction: false, advertisingIdentifier: nil)
    }
    
    
    func setHelpUnitInfo(_ application : UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
//        DispatchQueue.main.async {
//            let builder = FlurrySessionBuilder.init()
//            builder.withCrashReporting(false)
//            builder.withAppVersion(AppData.share.App_version)
//            Flurry.setShowErrorInLogEnabled(true)
//            Flurry.startSession(flurrySession, withOptions: launchOptions, with: builder)
//        }
        // add Fabric
//        Fabric.with([Crashlytics.self])
        
        HelpshiftCore.initialize(with: HelpshiftAll.sharedInstance())
        HelpshiftCore.install(forApiKey: helpshiftKey, domainName: helpshiftDomainName, appID: helpshiftAppid)
       
        //        JPUSHService.setDebugMode()
        //Um
//        UMSocialManager.default().openLog(true)
//        UMSocialManager.default().umSocialAppkey = UMSocialkey
//        UMSocialManager.default().setPlaform(.wechatSession, appKey: weixinKey, appSecret: weixinSercet, redirectURL: nil)
//        UMSocialManager.default().setPlaform(.sina, appKey: weiboKey, appSecret: weiboSercet, redirectURL: nil)
//        UMSocialManager.default().setPlaform(.twitter, appKey: twitter_key, appSecret: twitter_secret, redirectURL: nil)
//        UMSocialManager.default().setPlaform(.facebook, appKey: facebook_key, appSecret: "", redirectURL: nil)
    }
    
    func gotoLogin(){
        let storyboard = UIStoryboard(name:"Login", bundle: nil)
        let startVC : LaunchWelcome = storyboard.instantiateViewController(withIdentifier: "lanchWelcome") as! LaunchWelcome
        startNavigationController = startVC
        nav1.viewControllers = [startNavigationController]
        window?.rootViewController=nav1
    }
    
    func gotoAddChildVC() {
        let storyboard=UIStoryboard(name:"Register", bundle: nil)
        startNavigationController=storyboard.instantiateViewController(withIdentifier: "childSetup")
        nav1.viewControllers = [startNavigationController]
        window!.rootViewController = nav1
    }
    
    func gotoMainVC() {
        let mainSB:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        startNavigationController=mainSB.instantiateViewController(withIdentifier: "showMainVC") as! MainVC
        nav1.viewControllers = [startNavigationController]
        window!.rootViewController = nav1
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        HelpshiftCore.registerDeviceToken(deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
    }
    //ios 10 notication
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if(notification.request.content.userInfo["origin"] as? String == "helpshift") {
            HelpshiftCore.handleNotification(withUserInfoDictionary: notification.request.content.userInfo, isAppLaunch: false, with: self.window?.rootViewController)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if(response.notification.request.content.userInfo["origin"] as? String == "helpshift") {
            HelpshiftCore.handleNotificationResponse(withActionIdentifier: response.actionIdentifier, userInfo: response.notification.request.content.userInfo, completionHandler: completionHandler)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps=userInfo["origin"] as? String {
            if aps=="helpshift"{
                HelpshiftCore.handleNotification(withUserInfoDictionary: userInfo, isAppLaunch: false, with: window?.rootViewController)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if PairCupHelper.share.isChooseAP() == true {
            helper.setmyBoolGetNoti(false)
            if helper.bgTask != nil  {
                application.endBackgroundTask(helper.bgTask)
                helper.bgTask = UIBackgroundTaskInvalid
            }
            
            helper.bgTask = application.beginBackgroundTask(expirationHandler: {
                application.endBackgroundTask(self.helper.bgTask)
                self.helper.bgTask = UIBackgroundTaskInvalid})
            
            helper.bgTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AppDelegate.checkCurrentSSID), userInfo: nil, repeats: true)
        }else{
            InvalidateTimer()
        }
    }
	
	@objc func checkCurrentSSID() {
        if helper.checkCurrentSSIDNeedShowBanner(){
            helper.setmyBoolGetNoti(true)
            let localNotification = UILocalNotification()
            let currentDate = Date()
            localNotification.fireDate = currentDate.addingTimeInterval(1.0)
            localNotification.timeZone = TimeZone.current
            localNotification.alertBody = Localizaed("Connected! Tap here to go back to Gululu.")
            localNotification.alertAction = Localizaed("Slide to View")
            localNotification.userInfo = ["id" : "SSID", "name" : "Gululu"]
            localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
	}
	
	// MARK: - application did Receive Local Notification
	func application(_ application: UIApplication, didReceive notification: UILocalNotification){
		UIApplication.shared.applicationIconBadgeNumber = 0
		UIApplication.shared.cancelAllLocalNotifications()
	}

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication){
        if  !PairCupHelper.share.isConnetGululuAP() {
            let login : Login? = GUser.share.getRealLogin()
            guard  login != nil else {
                return
            }
            guard login?.passwd != nil else{
                return
            }
            BHGululuLog().uploadLogFile(gululu_log_name)
            checkUserPassword()
        }
        
        if PairCupHelper.share.isChooseAP() == true   {
            InvalidateTimer()
        }
        UIApplication.shared.applicationIconBadgeNumber=0
    }
    
    func InvalidateTimer() {
        PairCupHelper.share.setChooseAP(false)
        if helper.bgTimer != nil {
            helper.bgTimer.invalidate()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Ray.testCoreDB" in the application's documents Application Support directory.
        let urls = 	FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "GululuData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                            NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //#pragma mark- JPUSHRegisterDelegate
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        //
        let userinfodic = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.superclass()!))!{
            JPUSHService .handleRemoteNotification(userinfodic)
        }
        completionHandler(0)
    }
    
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        //
        let userinfodic = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.superclass()!))!{
            JPUSHService .handleRemoteNotification(userinfodic)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let origin : String = userInfo["origin"] as! String
        if origin == "helpshift"{
            HelpshiftCore.handleNotification(withUserInfoDictionary: userInfo, isAppLaunch: true, with: self.window?.rootViewController)
        }
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func checkUserPassword() {
        if Common.checkInternetConnection(){
            GUser.share.checkUserPassword({ result in
                if result == false{
                    DispatchQueue.main.async {
                        self.showPasswordRevokeDiy()
                    }
                }
            })
        }
    }
    
    func showPasswordRevokeDiy() {
        let alertView = BHAlertView(frame: (window?.frame)!)
        alertView.initAlertContent(Localizaed("Oops..."), message: Localizaed("Your account password may have been changed on another device. Please sign in again with the new password."), leftBtnTitle: "", rightBtnTitle: OK)
        alertView.delegate = self
        alertView.presentBHAlertView()
    }
    
    func rightButtonDelegateAction() {
        let loginVC:LoginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginVC
        nav1.viewControllers[0]=loginVC
        if Common.checkPreferredLanguages() == 1{
            loginVC.vcModel = .inputPhoneNumber
        }else{
            loginVC.vcModel = .inputEmail
        }
        GUser.share.userLogOut()
        _ = nav1.popToRootViewController(animated: true)
    }

    func cancleButtonDelegateAction() {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if helper.isLandScape(){
            return .landscapeRight
        }else{
            return .portrait
        }
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.scheme == "Gululu"{
            DispatchQueue.main.async {
                if url.host == "share"{
                    self.showShareView()
                }else if url.host == "openUrl"{
                    self.openUrlFromAvtivety(url.query!)
                }else if url.host == "SafariOpenUrl"{
                    let urlWithSn = url.query! + "?sn=" + GUser.share.getUserSn()
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: urlWithSn)!, options: ["":""], completionHandler: { (result) in
                            //
                        })
                    } else {
                         UIApplication.shared.openURL(URL(string: urlWithSn)!)
                    }
                }else if url.host == "openUrlWithSN"{
                    let urlWithSn = url.query! + "?sn=" + GUser.share.getUserSn()
                    self.openUrlFromAvtivety(urlWithSn)
                }else if url.host == "openHelpShiftCampaigns" {
                    HelpshiftCampaigns.showInbox(on: self.startNavigationController, with: nil)
                }
                
            }
        }else if url.scheme == "wb2795399026"{
            
        }else if url.scheme == "wx48defbc45d2b2324"{
            
        }else if url.scheme == "fb140528403336921"{
            
        }else if url.scheme == "gululu"{
            if url.host == "openHelpShiftCampaigns" {
                HelpshiftCampaigns.showInbox(on: self.startNavigationController, with: nil)
            }
        }
        return true
    }
    
    //share
    func showShareView() {
//        //Flurry.logEvent("Main_helpshift_share_bth_click")
//        for controller in nav1.viewControllers as Array {
//            if controller.isKind(of: MainVC.self) {
//                let vc : MainVC = controller as! MainVC
//                vc.show_share_view_in_window()
//            }
//        }
    }
    
    func openUrlFromAvtivety(_ shareUrl : String) {
        let broswerView = BrowserViewController()
        broswerView.webURL = shareUrl
        nav1.viewControllers.first?.present(broswerView, animated: true, completion: nil)
    }
    
    func addNotifacationNetWork() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: helper.reachability)
        do{
            try helper.reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        switch helper.reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    func stopNotication_netWork() {
        helper.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: helper.reachability)
    }
    
}

