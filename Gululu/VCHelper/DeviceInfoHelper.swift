//
//  GameVersionHelper.swift
//  Gululu
//
//  Created by Baker on 17/4/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

struct Version {
    var package_name : String?
    var package_verson : String?
    var next_package : String?
    init(_ packageName : String?,packageVersion : String?,nextPackage : String?) {
        self.package_name = Localizaed(packageName)
        self.package_verson = packageVersion
        self.next_package = nextPackage
    }
}

class DeviceInfoHelper: NSObject {

    static let share = DeviceInfoHelper()
    
    var pageArray = [Version]()
    var appVersionArray = [Version]()
    let appVersionName = "App"
    let newAppSignText = Localizaed("new")
    let Game = Localizaed("Game")
    let Firmware = Localizaed("Firmware")
    let Network = Localizaed("Network")
    let defaultVersion = "null"
    
    func getGameVersion(_ cloudCallback:@escaping (Bool) -> Void) {
        if !Common.checkInternetConnection() {
            return
        }
        
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url: getCupGameVersionUrl())
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let status : String? = dic["status"] as? String
                let gameVersion : String? = dic["game_version"] as? String
                if status == "OK"{
                    cloudCallback(true)
                    self.saveGameVersioninDB(gameVersion)
                }else{
                    cloudCallback(false)
                }
            }else{
                cloudCallback(false)
            }
        })
    }
    
    
    func saveGameVersioninDB(_ gameVersion : String?) {
        guard gameVersion != nil else {
            return
        }
        let key = gameVersionKey + activeChildID
        UserDefaults.standard.set(gameVersion, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func readGameVersionfromDB() -> String {
        let key = gameVersionKey + activeChildID
        let gameVersion = UserDefaults.standard.object(forKey: key)
        guard gameVersion != nil else {
            return ""
        }
        return gameVersion as! String
    }
    
    func checkAndGetChildDeviceInfo(){
        guard activeChildID != "" else {
            return
        }
        getDevicoInfoWithOutCallback()

    }
    
    func getDevicoInfoWithOutCallback() {
        if !Common.checkInternetConnection() {
            readDeviceInfoFromChild()
            return
        }
        
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:getDeviceInfoUrl(GCup.share.readCupIDFromDB()))
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                if dic["versions"] == nil {
                    self.setPageArrayWhenitHaveOnlyAPP()
                    return
                }
                let deviceVerisons : NSArray = dic["versions"] as! NSArray
                self.saveDiceInfoWithChild(deviceVerisons)
                self.handleVersionArrayToVerionItem(deviceVerisons)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: newSignObserverNotiStr), object: nil)
                }
            }else{
                self.readDeviceInfoFromChild()
            }
        })
    }
    
    func handleVersionArrayToVerionItem(_ versionArray:NSArray)  {
        guard versionArray.count != 0 else {
            setPageArrayWhenitHaveOnlyAPP()
            return
        }
        resetPageArray()
        for i in 0...versionArray.count-1{
            let pageInfo : NSDictionary = versionArray[i] as! NSDictionary
            let versionItem : Version = Version(pageInfo["package_name"] as? String, packageVersion: pageInfo["current_version"] as? String, nextPackage: pageInfo["latest_version"] as? String)
            if versionItem.package_name == Game{
                pageArray.remove(at: 0)
                pageArray.insert(versionItem, at: 0)
            }else if versionItem.package_name == Firmware{
                pageArray.remove(at: 1)
                pageArray.insert(versionItem, at: 1)
            }else if versionItem.package_name == Network{
                pageArray.remove(at: 2)
                pageArray.insert(versionItem, at: 2)
            }else{
                pageArray.append(versionItem)
            }
        }
    }
    
    func resetPageArray() {
        pageArray.removeAll()
        let appVerionItem = Version(appVersionName, packageVersion: GVersion.share.appVer!, nextPackage: GVersion.share.newAppVerSion)
        pageArray.append(appVerionItem)
        pageArray.append(appVerionItem)
        pageArray.append(appVerionItem)
    }
    
    func setPageArrayWhenitHaveOnlyAPP() {
        pageArray.removeAll()
        let appVerionItem = Version(appVersionName, packageVersion: GVersion.share.appVer!, nextPackage: GVersion.share.newAppVerSion)
        pageArray.append(appVerionItem)
    }
    
    func justAppVersionn() {
        appVersionArray.removeAll()
        let appVerionItem = Version(appVersionName, packageVersion: GVersion.share.appVer!, nextPackage: GVersion.share.newAppVerSion)
        appVersionArray.append(appVerionItem)
    }
    
    func isShouldShowNewIcon() -> Bool {
        guard pageArray.count != 0 else {
            return false
        }
        for versionItem : Version in pageArray {
            let currentVersion = versionItem.package_verson
            let nextVersion = versionItem.next_package
            if GVersion.share.compareVersion(currentVersion!, version2: nextVersion!) == -1{
                return true
            }
        }
        return false
    }
    
    func isFirstNewVersionAtPostion() -> Int {
        guard pageArray.count != 0 else {
            return 0
        }
        for i in 0...pageArray.count-1{
            let versionItem : Version = pageArray[i]
            let currentVersion = versionItem.package_verson
            let nextVersion = versionItem.next_package
            if GVersion.share.compareVersion(currentVersion!, version2: nextVersion!) == -1{
                return i
            }
        }
        return 0
    }
    
    func isNewVersion(_ versionItem:Version) -> Bool {
        let currentVersion = versionItem.package_verson
        let nextVersion = versionItem.next_package
        if GVersion.share.compareVersion(currentVersion!, version2: nextVersion!) == -1{
            return true
        }else{
            return false
        }
    }
    
    func saveDiceInfoWithChild(_ versionArray:NSArray) {
        let key1 = activeChildID + saveDeviceInfoKey
        UserDefaults.standard.set(versionArray, forKey: key1)
        UserDefaults.standard.synchronize()
    }

    func readDeviceInfoFromChild() {
        pageArray.removeAll()
        let key1 = activeChildID + saveDeviceInfoKey
        let versionArray : NSArray? = UserDefaults.standard.object(forKey: key1) as! NSArray?

        if versionArray == nil || versionArray?.count == 0{
            setPageArrayWhenitHaveOnlyAPP()
        }else{
            handleVersionArrayToVerionItem(versionArray!)
        }
    }
    
    func readDeviceInfoFromOneChild(_ child: Children) -> [Version] {
        guard child.childID != nil else {
            return [Version]()
        }
        var versionItemArray = [Version]()
        let key1 = activeChildID + saveDeviceInfoKey
        let versionArray : NSArray? = UserDefaults.standard.object(forKey: key1) as! NSArray?
        if versionArray?.count == 0 || versionArray == nil{
            return versionItemArray
        }
        for i in 0...(versionArray?.count)!-1{
            let pageInfo : NSDictionary = versionArray![i] as! NSDictionary
            if pageInfo.count == 0{
                return [Version]()
            }
            let versionItem : Version? = Version(pageInfo["package_name"] as? String, packageVersion: pageInfo["current_version"] as? String, nextPackage: pageInfo["latest_version"] as? String)
            versionItemArray.append(versionItem!)
        }
        return versionItemArray
    }
    
    func getGameVerion(_ child : Children) -> String {
        let versionArray = readDeviceInfoFromOneChild(child)
        guard versionArray.count != 0 else {
            return defaultVersion
        }
        for i in 0...versionArray.count - 1{
            let version : Version = versionArray[i]
            if version.package_name == Game{
                return version.package_verson!
            }
        }
        return defaultVersion
    }
    
    func getNetworkVersion(_ child : Children) -> String {
        let versionArray = readDeviceInfoFromOneChild(child)
        guard versionArray.count != 0 else {
            return defaultVersion
        }
        for i in 0...versionArray.count - 1{
            let version : Version = versionArray[i]
            if version.package_name == Network{
                return version.package_verson!
            }
        }
        return defaultVersion
    }
    
    func getFirmwareVersion(_ child : Children) -> String {
        let versionArray = readDeviceInfoFromOneChild(child)
        guard versionArray.count != 0 else {
            return defaultVersion
        }
        for i in 0...versionArray.count - 1{
            let version : Version = versionArray[i]
            if version.package_name == Firmware{
                return version.package_verson!
            }
        }
        return defaultVersion
    }
    
}
