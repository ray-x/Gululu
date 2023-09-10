//
//  PairCupHelper.swift
//  Gululu
//
//  Created by Baker on 17/4/5.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class PairCupHelper: NSObject {

    static let share = PairCupHelper()
    
    private var chooseAP: Bool = false
    let con = TCPConnection.share
    var userSelectWifiName : String?
    var userSelectWifiPassword : String?
    var gululuSsid : String?
    var gululuWifiAddress : String?
    var isGululuAP: Bool = false
    var contain5G: Bool = false
    var detailArray = [String]()
    var connect_cup_timer: DispatchSourceTimer?
    var verify_connect_time : Int = 5

    func deinitTimer() {
        if connect_cup_timer != nil{
            connect_cup_timer?.cancel()
            connect_cup_timer = nil
            verify_connect_time = 5
        }
    }
    
    func iOS11Later() -> Bool {
        if #available(iOS 11.0, *)
        {
            return true
        }else{
            return false
        }
    }
    
    func setDetailArrayFromSysterm()  {
        if(detailArray.count != 0)
        {
            return
        }
        let oneStr = Localizaed("Press and hold the main button\r until the screen lights up")
        let twoStr =  Localizaed("Then, long press the main button\r to enter the menu")
        let threeStr = Localizaed("Press it again to show your Gululu's ID\r and stay on this page")
        let iOS11LastStr = Localizaed("Now, switch your wifi connection to the\r one that matches your Gululu’s ID")
        let iOS11LaterStr = Localizaed("Please input the ID shows in your Gululu")

        detailArray.append(oneStr)
        detailArray.append(twoStr)
        detailArray.append(threeStr)
        
        if iOS11Later()
        {
            detailArray.append(iOS11LaterStr)
        }else
        {
            detailArray.append(iOS11LastStr)
        }
        
    }
    
    func isChooseAP() -> Bool {
        return chooseAP
    }
    
    func setChooseAP(_ choose: Bool) {
        chooseAP = choose
    }
    
    func resetAllGululuData() {
        getSSIDFromCon()
        getAddrFromCon()
        _ = getIsGluluAPBoolValue()
        getIsContain5GValue()
    }
    
    func getSSIDFromCon() {
        let ssidinCon: String? = con.getInterfaces()
        if ssidinCon == "" || ssidinCon == nil{
            gululuSsid = ""
        } else {
            gululuSsid = ssidinCon
        }
    }
    
    func IsConnectValiedWiFi() -> Bool {
        let ssidinCon: String? = con.getInterfaces()
//        let ssidinCon1: String? = con.getSSID()

        if(ssidinCon == "")
        {
            return false;
        }else{
            return true;
        }
    }

    func getAddrFromCon() {
        let ipaddr : String? = con.getWiFiAddress()
        if ipaddr == "" || ipaddr == nil {
            gululuWifiAddress = ""
        }else{
            gululuWifiAddress = ipaddr
        }
    }
    
    func getIsGluluAPBoolValue() -> Bool{
        guard gululuSsid != "" || gululuWifiAddress != "" else {
            isGululuAP = false
            return false
        }
        let regex = try! NSRegularExpression(pattern: "^U[0-9A-F]{4}$", options: .caseInsensitive)
        let ssidRet = regex.matches(in: gululuSsid!, options: [], range: NSRange(location: 0, length: (gululuSsid?.count)!)).count
        let addrRet = gululuWifiAddress?.range(of: "192.168.21")
        
        if ssidRet == 1 && addrRet != nil {
            isGululuAP = true
            return true
        }else{
            isGululuAP = false
            return false
        }
    }

    func getCurrentWifiAddressFromCon() -> String? {
        let ipaddr : String? = TCPConnection().getWiFiAddress()
      
        if ipaddr == "" || ipaddr == nil{
            return ""
        }
        return ipaddr
    }
    
    func isConnetGululuAP() -> Bool {
        let currnetWifiAddress = getCurrentWifiAddressFromCon()
        if ((currnetWifiAddress?.range(of: "192.168.21")) != nil) {
            return true
        }else{
            return false
        }
    }
    
    func getIsContain5GValue() {
        guard gululuSsid != "" else {
            contain5G = false
            return
        }
        if (gululuSsid?.contains("5G"))! || (gululuSsid?.contains("5g"))! {
            contain5G = true
            return
        }
        contain5G = false
    }
    
    
    func checkCloudAvalibility() -> Bool {
        var health: Bool = false
        for _ in 0 ..< 15 {
            
            if health { break }
            
            cloudObj().checkHealth({ (success) in
                if success.boolValue { health = true }
            })
            sleep(1)
        }
        return health
    }
    
    func isInternetWork() -> Bool {
        var retryTime   = 0
        var newSSID     = con.getInterfaces()
        let regexSSID   = try! NSRegularExpression(pattern: "^U[0-9A-F]{4}$", options: .caseInsensitive)
        
        while newSSID == "" || newSSID == gululuSsid || regexSSID.matches(in: newSSID, options: [], range: NSRange(location: 0, length: newSSID.count)).count == 1 || con.getWiFiAddress()?.range(of: "192.168.21") != nil {
            sleep(1)
            retryTime  += 1
            newSSID     = con.getInterfaces()
            
            if retryTime == 15 { return false } else { continue }
        }
        return true
    }
    
    func collectOrderArray() -> NSMutableArray {
        let ssidCmd = "ssid:" + userSelectWifiName!
        let pwd     = "pwd:" + userSelectWifiPassword!
        
        let msgArray = NSMutableArray()
        
        msgArray.insert(ssidCmd, at: msgArray.count)
        msgArray.insert(pwd, at: msgArray.count)
        
        if GUser.share.appStatus == .bindCup {
            let child_sn = "child_sn:" + "\(activeChildID)"
            msgArray.insert(child_sn, at: msgArray.count)
        }
        
        msgArray.insert("tosta:Connect Cup", at: msgArray.count)
        return msgArray
    }
    
    func log_update_failedLog() {
        let pairStr = String(format:"Gululu ap: %@",gululuSsid!)
        BH_Log(pairStr, logLevel: .pair)
        let ssidStr = String(format:"ssid: %@",userSelectWifiName!)
        BH_Log(ssidStr, logLevel: .pair)
        let pwdStr = String(format:"pwd-length: %d",(userSelectWifiPassword?.count)!)
        BH_Log(pwdStr, logLevel: .pair)
    }
    
    func pairOKLog() {
        let nowTimeInterveral = BKDateTime.getNowTimeIntervel()
        let pairOKStr = String(format:"[\"Pair_OK\":\"%d\"]",nowTimeInterveral)
        BH_Log(pairOKStr, logLevel: .pair)
    }
    
    func pairFailedLog() {
        let nowTimeInterveral = BKDateTime.getNowTimeIntervel()
        let pairFailedStr = String(format:"[\"Pair_Failed\":\"%d\"]",nowTimeInterveral)
        BH_Log(pairFailedStr, logLevel: .pair)
    }
    
    func updateOKLog()  {
        let nowTimeInterveral = BKDateTime.getNowTimeIntervel()
        let updateOKStr = String(format:"[\"Update_OK\":\"%d\"]",nowTimeInterveral)
        BH_Log(updateOKStr, logLevel: .pair)
    }
    
    func updateFialedLog()  {
        
        let nowTimeInterveral = BKDateTime.getNowTimeIntervel()
        let updateFailedStr = String(format:"[\"Update_Failed\":\"%d\"]",nowTimeInterveral)
        BH_Log(updateFailedStr, logLevel: .pair)

    }
    
    func getPairScrollerImageArray() -> [String]{
        if iOS11Later(){
            return ["pair_cup_lanuch_1", "pair_cup_lanuch_2", "pair_cup_lanuch_3", "match_gululu_id_ios11"]
        }else{
            return ["pair_cup_lanuch_1", "pair_cup_lanuch_2", "pair_cup_lanuch_3", "match_gululu_id"]
        }
    }
    
    func getPairTitleFromPage(_ page: Int) -> String {
        if page == -1{
            return Localizaed("Choose your home Wi-Fi")
        }else if Float(page) < 1.5 && page > -1{
            return Localizaed("Step ②: Power on your Gululu")
        }else{
            return Localizaed("Step ③: Connect to your Gululu")
        }
    }
    
    func getPairDetailInfoFromPage(_ page: Int) -> String {
        setDetailArrayFromSysterm()
        var pageInt = page
        if pageInt < 0{
            pageInt = 0
        }
        if pageInt > detailArray.count{
            pageInt = detailArray.count
        }
        return detailArray[pageInt]
    }
}
