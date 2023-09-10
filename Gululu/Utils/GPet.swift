//
//  GPet.swift
//  Gululu
//
//  Created by Baker on 17/1/9.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

enum ShowPetStatus {
    case noPet
    case active
    case finish
    case byeBye
    case sync
    case change
}

class GPet: NSObject {
    
    static let share = GPet()
    var showPetStatus : ShowPetStatus = .noPet
    var can_add_pet : Bool = false
    var pet_notify_level : NSNumber = NSNumber(value: -1)
    var syncPetName : String = ""
    var showPet : Pets?
    var chosePetSucced : Bool = false
    var petDeep : Int = 3500
    let pet2Deep : Int = 2100
    var chosePetName : String = ""
    var chosePet : Pets?
    var petList = [Pets]()
    let active = "ACTIVE"
    let next = "NEXT"
    let finish = "FINISH"
    let deactive = "DEACTIVE"
    let upgrade = "UGRADE"
    let NINJI2 = "NINJI2"
    let SANSA2 = "SANSA2"
    let PURPIE2 = "PURPIE2"
    let DONNY2 = "DONNY2"
    
    let Egg = "egg"
    let pet3DArray = ["SANSA2", "NINJI2", "PURPIE2", "DONNY2"]
    let petImageNameArray = ["SANSA", "NINJI", "PURPIE", "DONNY"]
    let pet2DArray = ["SANSA","NINJI","PURPIE"]
    var nextSelectPets : NSMutableArray?
    var oldPet_petNum: NSNumber?
    
    let petDesp=["Ninji":Localizaed("He has ninja powers,\r stands up for justice,\r He is calm under pressure.\r Help him fulfill his dreams!"),
                 "Sansa": Localizaed("Sansa is a princess,\r Loves beauty and kindness.\r Bestowed with three wands,\r She owns magic that you wants.\r One emits star powder,\r Which brings positive power.\r The other two hide mysteries,\r So it needs you to discover."),
                 "Purpie" :  Localizaed("Purpie is so cute,\r And she loves food.\r Always carry a bag,\r With magic inside.\r Anything goes in,\r Food comes out.\r No matter what appears,\r She eats with no doubt.")]
    
    func updateChildPet() {
        let pet: Pets? = createObject(Pets.self)!
        pet!.childID = activeChildID
        pet!.update(.fetchAll, uiCallback: { _ in})
    }
    
    func displayCurrentPet(_ cloudCallback:@escaping ()->Void){

        if activeChildID == ""{
            cloudCallback()
            return
        }
        
        readPetFromeLocal()
        saveOldPetInMermory()
        
        if !Common.checkInternetConnection() {
            noUpdatePetCallBack(cloudCallback)
        }
        if localHavePet(){
            updatePetFromRemote(cloudCallback)
        }else{
            createPetFromPet(cloudCallback)
        }
    }
    
    func saveOldPetInMermory(){
        oldPet_petNum = nil
        let activePet = getActivePetInPetList()
        if activePet != nil{
            oldPet_petNum = activePet?.petNum
        }
    }
    
    func updatePetFromRemote(_ cloudCallback:@escaping ()->Void) {
        var pet = petList.first
        if pet == nil {
            pet = createObject(Pets.self)!
        }
        pet!.update(.fetchAll, uiCallback: { result in
            self.getPetsFromLocal(cloudCallback)
        })
    }
    
    func createPetFromPet(_ cloudCallback:@escaping ()->Void) {
        let pet:Pets = createObject(Pets.self)!
        pet.update(.fetchAll, uiCallback: { result in
            self.getPetsFromLocal(cloudCallback)
        })
    }
    
    func getPetsFromLocal(_ cloudCallback:@escaping ()->Void){
        readPetFromeLocal()
        if localHavePet(){
            if oldPet_petNum == nil {
                noUpdatePetCallBack(cloudCallback)
            }else {
                updatePetCallBack(cloudCallback)
            }
        }else{
            noPetCallBack(cloudCallback)
        }
    }

    func noPetCallBack(_ cloudCallback:@escaping ()->Void) {
        showPetStatus = .noPet
        cloudCallback()
    }
    
    func noUpdatePetCallBack(_ cloudCallback:@escaping ()->Void) {
        
        let nextPet = getNextPetInPetList()
        let activePet = getActivePetInPetList()
        if nextPet == nil {
            guard  activePet != nil else {
                showPetStatus = .noPet
                cloudCallback()
                return
            }
            showPet = activePet
            showPetStatus = .active
        }else{
            let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
            if childHasBotleState == .both{
                syncPetName = nextPet!.petName!
                showPetStatus = .sync
                showPet = activePet
            }else{
                showPetStatus = .active
            }
        }
        cloudCallback()
    }
    
    func updatePetCallBack(_ cloudCallback:@escaping ()->Void) {
        let nextPet = getNextPetInPetList()
        let activePet = getActivePetInPetList()
        if nextPet != nil {
            let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
            if childHasBotleState == .both{
                syncPetName = nextPet!.petName!
                showPetStatus = .sync
                showPet = activePet
            }else{
                showPet = activePet
                showPetStatus = .active
            }
        }else{
            for petInList in petList {
                if petInList.petNum == oldPet_petNum{
                    if petInList.petStatus == finish{
                        chosePetSucced = true
                        chosePetName = (activePet?.petName)!
                        showPet = get_pet_form_petList_by_petNum(oldPet_petNum!)
                        showPetStatus = .byeBye
                        break
                    }else{
                        let activePet = getActivePetInPetList()
                        guard  activePet != nil else {
                            showPetStatus = .noPet
                            cloudCallback()
                            return
                        }
                        showPet = activePet
                        showPetStatus = .active
                        cloudCallback()
                        return
                    }
                }
            }
        }
        cloudCallback()
    }
    
    func readPetFromeLocal() {
        petList.removeAll()
        guard activeChildID != "" else {
            return
        }
        let petListinLocal : [Pets]? = createObjects(Pets.self,id:activeChildID) as? [Pets]
        guard petListinLocal != nil else {
            return
        }
        for pet in petListinLocal!{
            if pet.petName == NINJI2{
                pet.petLevel = NSNumber(value: 100)
            }else if pet.petName == SANSA2{
                pet.petLevel = NSNumber(value: 200)
            }else if pet.petName == PURPIE2{
                pet.petLevel = NSNumber(value: 300)
            }else if pet.petName == DONNY2{
                pet.petLevel = NSNumber(value: 400)
            }
        }
        petList = (petListinLocal?.sorted(by: {$0.petLevel!.floatValue < $1.petLevel!.floatValue }))!
    }
    
    func getNoRepeatPets() -> [Pets]{
        var resultPets = [Pets]()
        guard petList.count != 0 else {
            return resultPets
        }
        let nextPet = getNextPetInPetList()
        if is3DPet(pet: nextPet){
            resultPets.append(nextPet!)
        }
        let activePet = getActivePetInPetList()
        if is3DPet(pet: activePet) {
            if !isSamePetName(activePet?.petName, petName2: nextPet?.petName){
                resultPets.append(activePet!)
            }
        }
        for pet1 in petList{
            var isexist = false
            for pet2 in resultPets {
                if isSamePetName(pet2.petName, petName2: pet1.petName) || is2DPet(pet: pet1){
                    isexist = true
                    break
                }
            }
            if isexist == false{
                if pet1.petStatus == finish{
                    resultPets.append(pet1)
                }
            }
        }
        resultPets = resultPets.sorted(by: {$0.petLevel!.floatValue < $1.petLevel!.floatValue })
        return resultPets
    }
    
    func isSamePetName(_ petName1:String?, petName2:String?) -> Bool{
        if isValidString(petName1) && isValidString(petName2){
            let new_petname1 = getPetImageName(petName1)
            let new_petname2 = getPetImageName(petName2)
            if new_petname1 == new_petname2{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    
    func localHavePet() -> Bool {
        let pet = petList.first
        if pet?.petNum == 0 || pet?.petNum == nil{
            return false
        }else{
            return true
        }
    }

    func activePetHaveFinish() -> Bool{
        let activePet = getActivePetInPetList()
        guard activePet?.cupID != nil else {
            return false
        }
        var petDeepInt : Int?
        if (activePet?.petName?.contains("2"))!{
            petDeepInt = pet2Deep
        }else{
            petDeepInt = petDeep
        }
        if activePet!.petDepth?.intValue < petDeepInt {
            return false
        }else{
            let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
            if childHasBotleState == .both{
                return true
            }else{
                return false
            }
        }
    }
    
    func getActivePetInPetList() -> Pets? {
        guard petList.count != 0 else {
            return nil
        }
        for pet in petList {
            if pet.petStatus == active{
                return pet
            }
        }
        return nil
    }
    
    func getNextPetInPetList() -> Pets? {
        guard petList.count != 0 else {
            return nil
        }
        for pet in petList {
            if pet.petStatus == next{
                return pet
            }
        }
        return nil
    }
    
    func changeShowPet(){
        let activePet = getActivePetInPetList()
        showPet = activePet
    }
    
    func createChildPet(_ cloudCallback:@escaping (Result<NSDictionary>)->Void){
        if chosePet == nil {
            chosePet = createObject(Pets.self)
        }
        chosePet!.petStatus = active
        chosePet!.childID = activeChildID
        chosePet?.petName = chosePetName
        chosePet!.update(.create, uiCallback: { result in
            cloudCallback(result)
        })
    }
    
    func addAnotherPet(_ cloudCallback:@escaping (Result<NSDictionary>)->Void){
        if chosePet == nil {
            chosePet = createObject(Pets.self)
        }
        chosePet!.childID = activeChildID
        chosePet?.petName = chosePetName
        chosePet?.update(.createNext, uiCallback: { result in
            cloudCallback(result)
        })
    }
    
    func upgradePet(_ cloudCallback:@escaping (Result<NSDictionary>)->Void) {
        if chosePet == nil {
            chosePet = createObject(Pets.self)
        }
        chosePet?.childID = activeChildID
        chosePet?.petName = chosePetName
        chosePet?.cupID = GCup.share.readCupIDFromDB()
        chosePet?.update(.upgrade, uiCallback: { result in
            cloudCallback(result)
        })
    }
    
    func add_next_pet(_ chosePet: String ,_ cloudCallback:@escaping (Int)->Void) {
        let requset = GUHttpRequest()
        requset.body["pet_model"] = chosePet
        requset.setRequestConfig(.post, url: getpetUrl())
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let next_pet = self.getNextPetInPetList()
                self.setNextPetToFinishPet(next_pet)
                Pet.savePet_frome_dic(dic)
                cloudCallback(0)
            }else{
                let err = result.error! as NSError
                let errorDic : NSDictionary = err.userInfo as NSDictionary
                let extra_info =  errorDic["extra_info"] as? String
                if extra_info == "cup version not support"{
                    cloudCallback(1)
                }else{
                   cloudCallback(2)
                }
            }
        })
        
    }
    
    func change_pet(_ chosePet: String ,_ cloudCallback:@escaping (Int)->Void) {
        let requset = GUHttpRequest()
        requset.body["change_pet_model"] = chosePet
        requset.setRequestConfig(.put, url: getpetUrl())
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let next_pet = self.getNextPetInPetList()
                self.setNextPetToFinishPet(next_pet)
                cloudCallback(0)
            }else{
                let err = result.error! as NSError
                let errorDic : NSDictionary = err.userInfo as NSDictionary
                let extra_info =  errorDic["extra_info"] as? String
                if extra_info == "cup version not support"{
                    cloudCallback(1)
                }else{
                    cloudCallback(2)
                }
            }
        })
        
    }

    func changePetName(petName : String?) -> String {
        let petNameStr = getPetImageName(petName)
        return Localizaed((petNameStr.capitalized))
    }

    func getPetImageName(_ petName: String?) -> String {
        guard petName != nil else{
            return "Ninji"
        }

        let littlePetName = petName?.uppercased()
        for petStr in petImageNameArray{
            if (littlePetName?.contains(petStr))!{
                return petStr.capitalized
            }
        }
        return "Ninji"
    }
    
    func getGamePets(_ cloudCallback:@escaping (NSArray)->Void)  {
        let requets = GUHttpRequest()
        requets.lastApiString = getpetOptionUrl()
        requets.httpType = .get
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let status : String? = dic["status"] as? String
                if status == "OK"{
                    cloudCallback( dic.object(forKey: "pet_types") as! NSArray)
                }else{
                    cloudCallback(self.pet3DArray as NSArray)
                }
            }else{
                cloudCallback(self.pet3DArray as NSArray)
            }
        })
    }
    
    func getNextPetsFromRemote(_ cloudCallback:@escaping (Bool)->Void) {
        can_add_pet = false
        pet_notify_level = NSNumber(value: -1)
        nextSelectPets?.removeAllObjects()
        let requets = GUHttpRequest()
        requets.lastApiString = getnextPetOptionUrl()
        requets.httpType = .get
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let status : String? = dic["status"] as? String
                if status == "OK"{
                    self.handleNextPetsFromRemote(dic)
                    cloudCallback(true)
                }
            }else{
                cloudCallback(false)
            }
        })
    }
    
    func handleNextPetsFromRemote(_ dic : NSDictionary?) {

        can_add_pet = dic?.object(forKey: "can_add_pet") as! Bool
        pet_notify_level = dic?.object(forKey: "pet_notify_level") as! NSNumber
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: can_add_pet_notication_name), object: nil)
        }
        let currnet_next_pet_count = dic?.object(forKey: "current_level_pet_count") as! Int
        if currnet_next_pet_count == 0{
            self.can_add_pet = false
        }
        if MianVCHepler.share.read_click_pet_button(){
            let next_pet_count = read_next_pet_count()
            if currnet_next_pet_count != next_pet_count{
                MianVCHepler.share.save_click_pet_button(false)
                return
            }
        }
        save_next_pet_count(currnet_next_pet_count)
        nextSelectPets = NSMutableArray()
        let petArray = dic?.object(forKey: "pet_types")
        nextSelectPets?.addObjects(from: petArray as! [Any])
    }
    
    func save_next_pet_count(_ count:Int) {
        let key = activeChildID + main_next_pet_count_key
        UserDefaults.standard.set(count, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func read_next_pet_count() -> Int {
        let key = activeChildID + main_next_pet_count_key
        let count = UserDefaults.standard.object(forKey: key)
        if count != nil{
            return count as! Int
        }
        return 1000
    }
    
    func getPetsFromService(){
        if !Common.checkInternetConnection() {
            return
        }
        let request = GUHttpRequest()
        request.lastApiString = getPetsUrl
        request.httpType = .get
        request.handleRequset(callback: { result in
        
        })
    }
    
    func is2DPet(pet:Pets?) -> Bool {
        if !isValidString(pet?.petName){
            return false
        }
        if pet2DArray.contains((pet?.petName)!){
            return true
        }
        return false
    }
    
    func is3DPet(pet:Pets?) -> Bool {
        if !isValidString(pet?.petName){
            return false
        }
        if pet3DArray.contains((pet?.petName)!){
            return true
        }
        return false
    }
    
    func getPetSelectTitle() -> String{
        return  String(format: Localizaed("Let %@\rchoose a pet!"),GChild.share.getActiveChildName())
    }
    
    func getfinsihandActivePetsName() -> [String] {
        readPetFromeLocal()
        var pets = [String]()
        for pet in petList{
            if pet.petStatus == finish || pet.petStatus == active{
                let newPetName = getPetImageName(pet.petName)
                if !pets.contains(newPetName){
                    pets.append(newPetName)
                }
            }
        }
        return pets
    }
    
    func ishaveFinishPet() -> Bool {
        readPetFromeLocal()
        guard petList.count != 0 else {
            return false
        }
        for pet in petList {
            if pet.petStatus == finish{
                return true
            }
        }
        return false
    }
    
    func syncPet(_ dic : NSDictionary,handleObject : NSObject) {
        let petList : [Pets]? = createObjects(Pets.self, id: activeChildID) as! [Pets]?
        if petList == nil{
            return
        }
        if cloudObj().getOperationFromObject(handleObject) == .fetchAll{
            for i in 0...(petList?.count)!-1 {
                let pet = petList?[i]
                backgroundMoc?.delete(pet!)
            }
        }else{
            for i in 0...(petList?.count)!-1 {
                let pet = petList?[i]
                 if pet?.petNum == 0 || pet?.petNum == nil{
                    backgroundMoc?.delete(pet!)
                }
            }
        }
        saveContext()
    }
    
    func getActivePetName() -> String {
        readPetFromeLocal()
        guard petList.count != 0 else {
            return "Ninji"
        }
        for pet in petList{
            if pet.petStatus == active{
                return getPetImageName(pet.petName)
            }
        }
        return "Ninji"
    }
    
    func get_pet_form_petList_by_petNum(_ pet_num: NSNumber) -> Pets? {
        guard petList.count != 0 else {
            return nil
        }
        for pet in petList{
            if pet.petNum == pet_num{
                return pet
            }
        }
        return nil
    }
    
    func checkPetIsActiveOrNext(_ pet:Pets?) -> Bool {
        if isValidString(pet?.petStatus){
            if pet?.petStatus == next || pet?.petStatus == active{
                return true
            }
            return false
        }
        return false
    }
    
    func checkPetIsActive(_ pet:Pets?) -> Bool {
        if isValidString(pet?.petStatus){
            if pet?.petStatus == active{
                return true
            }
            return false
        }
        return false
    }
    
    func checkPetIsFinsih(_ pet:Pets?) -> Bool {
        if isValidString(pet?.petStatus){
            if pet?.petStatus == finish{
                return true
            }
            return false
        }
        return false
    }
    
    func checkPetIsNext(_ pet:Pets?) -> Bool {
        if isValidString(pet?.petStatus){
            if pet?.petStatus == next{
                return true
            }
            return false
        }
        return false
    }
    
    func setNextPetToFinishPet(_ pet:Pets?) {
        if isValidString(pet?.petStatus){
            if pet?.petStatus == next{
                pet?.petStatus = finish
                saveContext()
            }
        }
    }
    
    
    //MARK: no use function
    func handleActivePet()  {
        if GUser.share.activeChild?.hasPet == 0 {
            GUser.share.activeChild?.hasPet = 1
        }
        var petDeepInt : Int?
        if (showPet?.petName?.contains("2"))!{
            petDeepInt = pet2Deep
        }else{
            petDeepInt = petDeep
        }
        if showPet!.petDepth?.intValue < petDeepInt {
            showPetStatus = .active
        }else{
            let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
            if childHasBotleState == .both{
                showPetStatus = .change
            }else{
                showPetStatus = .active
            }
        }
    }
    
    
}
