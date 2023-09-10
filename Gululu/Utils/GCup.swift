//
//  GCup.swift
//  Gululu
//
//  Created by Baker on 17/3/8.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GCup: NSObject {

    static let share = GCup()
    
    func refleshChildCup(child : Children?){
        guard child != nil else {
            return
        }

        var cup:Cups? = createObject(Cups.self, objectID: child?.childID)
        if child?.hasCup == 1 {
            if cup == nil{
                cup = createObject(Cups.self)
            }
            cup!.childID = child?.childID
            cup!.update(.fetchAll, uiCallback: { r in
                if r.boolValue {
                    guard cup?.cupID != nil else{
                        return
                    }
                    if child?.childID == activeChildID{
                        MainUpgrade.shareInstance.checkUpgradePetStatus(child?.childID)
                    }
                }
            })
        }
        if cup != nil && child?.hasCup == 0{
            backgroundMoc?.delete(cup!)
            saveContext()
        }
    }
    
    func updateChildCup() {
        let cup: Cups? = createObject(Cups.self)!
        cup!.childID = activeChildID
        cup!.update(.fetchAll, uiCallback: { _ in})
    }
    
    func readCupIDFromDB() -> String {
        let cup:Cups? = createObject(Cups.self, objectID: activeChildID)
        guard cup != nil else {
            BH_ERROR_LOG("read cup id when cup is nil")
            return ""
        }
        guard cup?.cupID != nil else {
            BH_ERROR_LOG("read cup id when cup id is nil")
            return ""
        }
        return (cup?.cupID)!
    }
    
    func readCupSnFromDB() -> String {
        let cup:Cups? = createObject(Cups.self, objectID: activeChildID)
        guard cup?.cupSN != nil else {
            return ""
        }
        return (cup?.cupSN)!
    }
    
    func readCupSnFromChild(_ child : Children) -> String {
        guard child.childID != nil else {
            return "null"
        }
        let cup:Cups? = createObject(Cups.self, objectID: child.childID)
        guard cup?.cupSN != nil else {
            return "null"
        }
        return (cup?.cupSN)!
    }
    
    
    func getChildCupList(_ cloudCallback:@escaping (Bool)->Void) {
        if PairCupHelper.share.isConnetGululuAP(){
            cloudCallback(false)
            return
        }
        let cupProvider: Cups = createObject(Cups.self)!
        cupProvider.update(.fetchAll, uiCallback: { result in
            guard result.boolValue == true else{
                cloudCallback(false)
                return
            }
            guard cupProvider.cupID != nil else {
                cloudCallback(false)
                return
            }
            GUser.share.activeChild?.hasCup = 1
            if GUser.share.appStatus == .bindCup {
                MainUpgrade.shareInstance.checkUpgradePetStatus(activeChildID)
            }
            cloudCallback(true)
        })
    }
    
    func updateChildCupInfo(_ cloudCallback:@escaping (Bool)->Void) {
        let child:Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return
        }
        child!.update(.fetch, uiCallback: { result in
            if result.boolValue == false{
                cloudCallback(false)
            }
        })
    }
    
    func  unpairCup(_ childid : String? , cloudCallback:@escaping (Bool)->Void) {
        guard childid != nil else {
            return
        }
        let cup:Cups? = createObject(Cups.self, objectID: childid)
        guard cup != nil else {
            cloudCallback(false)
            let child : Children? = createObject(Children.self, objectID: childid)
            guard  childid != nil else {
                return
            }
            refleshChildCup(child: child)
            return
        }
        cup!.remove(uiCallback: { result in
            switch result {
            case .Error:
                cloudCallback(false)
            case .Success:
                let child:Children? = createObject(Children.self, objectID: childid)
                if child?.childID != nil{
                    child?.hasCup = 0
                    saveContext()
                }
                cloudCallback(true)
            }
        })
    }
    
    func readCupSSID(_ childid : String?) -> String {
        guard childid != nil else {
            return ""
        }
        let cup:Cups? = createObject(Cups.self, objectID: childid)
        if  cup != nil && cup?.ssid != nil {
            return  cup!.ssid!
        }else{
            return  ""
        }
    }
    
    func syncCup(_ dic : NSDictionary,handleObject : NSObject) {
        let cupList : [Cups]? = createObjects(Cups.self, id: activeChildID) as! [Cups]?
        if cupList?.count == 0 || cupList == nil{
            return
        }
        
        if cloudObj().getOperationFromObject(handleObject) == .fetchAll{
            for i in 0...(cupList?.count)!-1 {
                let cup = cupList?[i]
                backgroundMoc?.delete(cup!)
            }
        }else{
            for i in 0...(cupList?.count)!-1 {
                let cup = cupList?[i]
                if cup?.cupID == nil {
                    backgroundMoc?.delete(cup!)
                }
            }
        }
        
        saveContext()
    }
    
    func get_child_pet_cup_level(_ cloudCallback:@escaping (Int) -> Void)  {
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get, url:get_child_cup_pet_level())
        requets.header["x_child_sn"] = GChild.share.getActiveChildID()
        requets.handleRequset(callback: { result in
            if result.boolValue {
                self.save_child_pet_cup_level(result.value)
                let resultInt = self.handle_child_pet_cup_level_result(result.value)
                cloudCallback(resultInt)
            } else {
                let defauletValue = self.read_child_pet_cup_level()
                cloudCallback(defauletValue)
            }
        })
    }
    
    func read_child_pet_cup_level() -> Int {
        let key = child_pet_cup_level_key + GChild.share.getActiveChildID()
        let dic : NSDictionary? = UserDefaults.standard.object(forKey: key) as? NSDictionary
        if isValidDic(dic){
            let resultInt = handle_child_pet_cup_level_result(dic!)
            return resultInt
        }else{
            BH_INFO_LOG("read child pet level when dic is no valid")
            return -1
        }
    }
    
    func save_child_pet_cup_level(_ dic: NSDictionary?) {
        guard isValidDic(dic) else {
            return
        }
        let key = child_pet_cup_level_key + GChild.share.getActiveChildID()
        UserDefaults.standard.set(dic, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func remove_child_pet_cup_level() {
        let key = child_pet_cup_level_key + GChild.share.getActiveChildID()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func handle_child_pet_cup_level_result(_ dic: NSDictionary?) -> Int {
        guard isValidDic(dic) else {
            BH_INFO_LOG("handle child pet level when dic is no valid")
            return -1
        }
        let resultLevel = dic?.object(forKey: "cup_level")
        return resultLevel as! Int
    }
    
}
