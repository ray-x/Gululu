//
//  MainUpgrade.swift
//  Gululu
//
//  Created by Baker on 16/12/30.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import Foundation
////import Flurry_iOS_SDK

enum PetUpgradeStatus : Int{
    case noNeed = 0
    case require
    case downloading
    case ready
    case upgrading
    case done
    
}

struct UpgradeInfoItem{
    var headImageName : String
    var bigImageName : String
    var upgradeTitle : String
    var upgradeDetailInfo : String
    var upgradeLongDN : String
    init (headImageName:String,bigImageName:String,upgradeTitle:String,upgradeDetailInfo:String,upgradeLongDN:String){
        self.headImageName = headImageName
        self.bigImageName = bigImageName
        self.upgradeTitle = upgradeTitle
        self.upgradeDetailInfo = upgradeDetailInfo
        self.upgradeLongDN = upgradeLongDN
    }
}

class MainUpgrade : NSObject {
    
    static let shareInstance = MainUpgrade()
    
    var petGradeStatus : PetUpgradeStatus = .noNeed
    
    var UPchildID : String = ""
    
    var withToHeight : CGFloat = 200/315
    
    var showView : Bool = false
    
    func checkUpgradePetStatus(_ childID : String?) {

        guard childID != nil else {
            return
        }
        UPchildID = childID!.appending(PetStatusNotifacationName)
        petGradeStatus = PetUpgradeStatus(rawValue: readPetStatusFromUserdefault())!
        
        let requets = GUHttpRequest()
        requets.setRequestConfig(.post,url: checkUpgradePetStatusUrl)
        requets.body["x_child_sn"] = activeChildID
        requets.body["x_cup_id"] = GCup.share.readCupIDFromDB()
        requets.handleRequset(callback: { result in
            if result.boolValue{
                self.updatePetGradeStatus(result.value?["upgrade_status"] as! String?)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: PetStatusNotifacationName), object: nil)
                }
            }
        })
    }
    
    func savePetStatusToUserdefault(petUpgradeStatus : PetUpgradeStatus) {
        UserDefaults.standard.set(petUpgradeStatus.rawValue, forKey:UPchildID)
    }
    
    func readPetStatusFromUserdefault() -> Int{
        let petStatus : Int? = UserDefaults.standard.object(forKey: UPchildID) as? Int
        if petStatus == nil{
            return 0
        }
        return petStatus!
    }
    
    func removePetStatusFromUserDefaule() {
        UserDefaults.standard.removeObject(forKey: UPchildID)
    }
    
    func updatePetGradeStatus(_ status : String?) {
        switch status! {
        case "upgrade_require":
            petGradeStatus = .require
        case "ready_to_upgrade_pet2":
            petGradeStatus = .ready
        case "upgrading":
            petGradeStatus = .upgrading
        case "no_upgrade_needed":
            if readPetStatusFromUserdefault() == 1{
                petGradeStatus = .downloading
            }else if readPetStatusFromUserdefault() == 2{
                petGradeStatus = .downloading
            }else if readPetStatusFromUserdefault() == 4{
                petGradeStatus = .done
            }else{
                petGradeStatus = .noNeed
            }
        default:
            petGradeStatus = .noNeed
        }
        
        sholdShowView(petGradeStatus)
        
        savePetStatusToUserdefault(petUpgradeStatus: petGradeStatus)
    }
    
    func sholdShowView(_ newStatus : PetUpgradeStatus) {
        let oldPetSatus : PetUpgradeStatus = PetUpgradeStatus(rawValue: readPetStatusFromUserdefault())!
        if oldPetSatus == .noNeed && newStatus == .require{
            showView = true
        }else if oldPetSatus == .noNeed && newStatus == .ready{
            showView = true
        }else if oldPetSatus == .require && newStatus == .ready{
            showView = true
        }else if oldPetSatus == .require && newStatus == .downloading{
            showView = true
        }else if oldPetSatus == .downloading && newStatus == .ready{
            showView = true
        }else if oldPetSatus == .upgrading && newStatus == .done{
            showView = true
        }else{
            showView = false
        }
    }
    func getPetUpgradeStatusStr() -> String{
        var titleStr : String?
        switch petGradeStatus {
        case .upgrading:
            titleStr = Localizaed("JUST ONE\nSTEP AWAY!")
        case .ready:
            titleStr = Localizaed("READY TO\nUPGRADE!")
        case .downloading:
            titleStr = Localizaed("DOWN-\nLOADING...")
        case .require:
            titleStr = Localizaed("UPGRADE\nAVAILABLE!")
        case .done:
            titleStr = Localizaed("ALL DONE,\nSTART NEW ADVENTURE!")
        default:
            titleStr = Localizaed("ALL DONE,\nSTART NEW ADVENTURE!")
        }
        return titleStr!
    }
    
    func getUpgradeButtonTitle() -> String{
        var buttontitle = ""
        
        switch petGradeStatus {
        case .require:
            buttontitle = Localizaed("UPGRADE")
        case .ready:
            buttontitle = Localizaed("CHOOSE NEW PET")
        case .upgrading, .downloading:
            buttontitle = Localizaed("GOT IT")
        case .done:
            buttontitle = DONE
        default:
            buttontitle = DONE
        }
        
        return buttontitle
    }
    
    func getUPGradePetButtonImageName(_ petName : String?) -> String {
        if petName == nil{
            return "UPNinji"
        }else{
            var petStr : String?
            if (petName?.contains("2"))!{
                petStr = petName?.replacingOccurrences(of: "2", with: "")
            }else{
                petStr = petName
            }
            petStr = petStr?.capitalized
            petStr = "UP" + petStr!
            return petStr!
        }
    }
    
    func getPetImageNameStr() -> String{
        if activeChildID == ""{
            return "UPNinji"
        }
        if GUser.share.activeChild?.hasPet == 0{
            return "UPNinji"
        }else{
            GPet.share.readPetFromeLocal()
            if GPet.share.localHavePet(){
                let activePet = GPet.share.getActivePetInPetList()
                if activePet == nil{
                    return "UPNinji"
                }else{
                    return getUPGradePetButtonImageName(activePet?.petName)
                }
            }else{
                return "UPNinji"
 
            }

        }
    }
    
    func getPetUpgradeImageStr() -> String{
        var imageName : String?
        
        switch petGradeStatus {
        case .upgrading:
            imageName = "upgradeIcon"
        case .ready:
            imageName = "upgradeIcon"
        case .require:
            imageName = "upgradeIcon"
        case .noNeed:
            imageName = "upgradeIcon"
        default:
            imageName = "upgradeIcon"
        }
        return imageName!
    }
    
    func setPetUpgradeData() -> [UpgradeInfoItem]{
        let allData = getUpgradeInfoItemData()
        var itemSource : [UpgradeInfoItem] = [UpgradeInfoItem]()
        switch petGradeStatus {
        case .require:
            itemSource = [allData[0],allData[1],allData[2],allData[3],allData[4]]
            break
        case .downloading:
            itemSource = [allData[6],allData[0],allData[1],allData[2],allData[4]]
            break
        case .ready:
            itemSource = [allData[0],allData[1],allData[2],allData[4]]
            break
        case .upgrading:
            itemSource = [allData[5]]
            break
        case .done:
            itemSource = [allData[0],allData[1],allData[2]]
            break
        default:
            break
        }
        return itemSource
    }
    
    func getUpgradeInfoItemData() -> [UpgradeInfoItem] {
        
        let item1 = UpgradeInfoItem(headImageName: "card01Thumb", bigImageName: "card01", upgradeTitle: Localizaed("3D Pets"), upgradeDetailInfo: Localizaed("All pets and animations are becoming 3D now!"), upgradeLongDN: Localizaed("All pets and animations are becoming 3D now!"))
        
        let item2 = UpgradeInfoItem(headImageName: "card02Thumb", bigImageName: "card02", upgradeTitle: Localizaed("New Adventures"), upgradeDetailInfo: Localizaed("New adventures and creative game play!"), upgradeLongDN: Localizaed("The new game play introduces more intuitive feedback and rewards for water drinking!"))
        
        let item3 = UpgradeInfoItem(headImageName: "card03Thumb", bigImageName: "card03", upgradeTitle: Localizaed("More Treasures"), upgradeDetailInfo: Localizaed("Treasure hunting has been immensely improved!"), upgradeLongDN: Localizaed("Much more undersea creatures, fantastic plants, and decorations for your pet!"))
        
        let item4 = UpgradeInfoItem(headImageName: "card04Thumb", bigImageName: "card04", upgradeTitle: Localizaed("How to upgrade?"), upgradeDetailInfo: Localizaed("Simple guides for you to upgrade your Gululu!"), upgradeLongDN: Localizaed("Power on your Gululu, then keep it on the charger for 4~6 hours with Wi-Fi connected. Gululu will download the upgrade patch all by itself! You’ll be informed in the App once it’s ready to upgrade."))
        
        let item5 = UpgradeInfoItem(headImageName: "card05Thumb", bigImageName: "card05", upgradeTitle: Localizaed("Your pet & progress"), upgradeDetailInfo: Localizaed("will be archived in “My Pets”."), upgradeLongDN: Localizaed("won’t appear in the new game. But you can still find your pet and plants in “My Pets”."))
        
        let item6 = UpgradeInfoItem(headImageName: "card06Thumb", bigImageName: "card06", upgradeTitle: Localizaed("Sync your Gululu"), upgradeDetailInfo: Localizaed("Sync your Gululu to enjoy the new adventures!"), upgradeLongDN: Localizaed("Put your Gululu on the charger, and it’ll restart after syncing. Get ready to enjoy the new adventures with your new pet!"))
        
        let item7 = UpgradeInfoItem(headImageName: "card07Thumb", bigImageName: "card07", upgradeTitle: Localizaed("Downloading…"), upgradeDetailInfo: Localizaed("Your Gululu is downloading the upgrade patch now."), upgradeLongDN: Localizaed("Your Gululu is downloading the upgrade patch now. It will take 4~6 hours or even longer. You’ll be informed in the App once it’s done."))
        
        return [item1,item2,item3,item4,item5,item6,item7]

    }
    
    func setUpgradeFlurryLog() {
        switch petGradeStatus {
        case .ready:
            //Flurry.logEvent("upgrade_open_ready")
            break
        case .require:
            //Flurry.logEvent("upgrade_open_require")
            break
        case .upgrading:
            //Flurry.logEvent("upgrade_open_sync")
            break
        case .done:
            //Flurry.logEvent("upgrade_open_finish")
            break
        case .downloading:
        //Flurry.logEvent("upgrade_open_downloading")
            break
        default:
            //Flurry.logEvent("upgrade_open_noNeed")
            break
        }
    }
    
}
