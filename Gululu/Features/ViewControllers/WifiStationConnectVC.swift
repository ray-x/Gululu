//
//  WifiStationConnect.swift
//  Gululu
//
//  Created by Ray Xu on 13/04/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

class WifiStationConnectVC: BaseViewController {
    var shouldRemove: Bool = false
    let connStatus = NetworkStatusNotifier()
    
//    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var wifiDetailINfo: UILabel!
    @IBOutlet weak var WifiTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WifiTitle.text = Localizaed("Connect to home wifi")
        wifiDetailINfo.text = Localizaed("Please connect to your home wifi to continue set up")
//        setButton.setTitle(Localizaed("Setting"), for: .normal)
        shouldRemove=true
        NetworkStatusNotifier().monitorNetworkChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: NetworkStatusChangedNotification), object: nil)
    }
    
    @objc func networkStatusChanged(_ notification: Notification)  {
        let networkStr = (notification as NSNotification).userInfo!["Status"] as! String
        if networkStr.contains("WiFi") {
            goto(vcName: "SSIDSetupVC", boardName: "PairCup")
            stopNotifier()
            return
        }
    }

    func stopNotifier() {
        if shouldRemove {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NetworkStatusChangedNotification), object: nil)
            shouldRemove = false
        }
    }
    
    deinit {
        stopNotifier()
    }
}
