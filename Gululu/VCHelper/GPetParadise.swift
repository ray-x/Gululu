//
//  PetParadiseModel.swift
//  Gululu
//
//  Created by Baker on 17/2/22.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GPetParadise: NSObject {
    
    static let share = GPetParadise()
    
    var widthProtion : CGFloat = SCREEN_WIDTH*3210/750
    let rateArray : NSArray = [-0.36,-0.32,-0.16,-0.08,-0.06,-0.03]
    var plantLayerNumArray  : NSArray = []
    let layerArray : NSArray = [0,1,2,3,4,5]
    let plantsNameArray : NSArray = ["plant1","plant2","plant3","plant4","plant5","plant6","plant7","plant8","plant9","plant10","plant11"]
    let width = FIT_SCREEN_HEIGHT(100)
    let height = FIT_SCREEN_WIDTH(100)
    let middleWidth = FIT_SCREEN_WIDTH(125)
    let ACWidth = FIT_SCREEN_HEIGHT(150)
    let ACheight = FIT_SCREEN_HEIGHT(150)
    let twoPetImageWidth : CGFloat = FIT_SCREEN_WIDTH(100)
    let headImageWidth = FIT_SCREEN_HEIGHT(200)
    let headSignWigth = FIT_SCREEN_WIDTH(20)
    var switch_pet_model = false
    var petArray : [String]?
    let bgImageTag = 10
    let petImageTag = 100
    let change_model_currnet_tag = 200
    let egg_button_tag = 499
    let limit_level_view_tag = 600
    let limit_show_no_pair_tag = 650
    let active_pet_tag = 700
    let change_model_pet_animtaion_image_tag = 1000
    var timer: DispatchSourceTimer?

    func getPetPlants(_ cloudCallback:@escaping (NSArray)->Void) {
        let plantArrayFromRemote : NSMutableArray = []
        
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url: getChildPlantUrl())
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let plants : [NSDictionary] = (result.value?.object(forKey: "plants") as! NSArray) as! [NSDictionary]
                for plant in plants{
                    let plantName = plant["name"]
                    plantArrayFromRemote.add(plantName ?? "")
                }
            }
            cloudCallback(plantArrayFromRemote)
        })
    }
    
    func getWhitchLayer(_ plantName : String?) -> Int {
        guard plantName != nil else {
            return 0
        }
        let index = plantNameToArrayIndex(plantName!)
        let layerIndex = addImageToWitchLayer(index)
        return layerIndex
    }
    
    func addImageToWitchLayer(_ plantIndex:Int) -> Int{

        if plantIndex > 0 && plantIndex < 5{
            return 1
        }else if plantIndex >= 5 && plantIndex < 9{
            return 2
        }else if plantIndex >= 9 && plantIndex < 11{
            return 3
        }else if plantIndex == 11{
            return 4
        }else{
            return 5
        }
    }
    
    func plantNameToArrayIndex(_ planName : String) -> Int {
        for i in 0...plantsNameArray.count-1{
            let plant : NSString = plantsNameArray[i] as! NSString
            if plant.isEqual(to: planName){
                return i+1
            }
        }
        return 0
    }
    
    func getLayelScrollRate(_ layer:Int) -> CGFloat {
        guard layer>=0 && layer<=5 else {
            return 1.00
        }
        let rate : Double = rateArray.object(at: layer) as! Double
        return CGFloat(1+rate*2)
    }
    
    func getChoseNextPetAinmationName(_ petName:String?) -> String {
        if isValidString(petName){
            let petNamecapital = GPet.share.getPetImageName(petName)
            let petNamelower = petNamecapital.lowercased
            return String(format:"%@_open_egg",petNamelower())
        }
        return "ninji_open_egg"
    }
    
    func getNextPetArray() -> [String] {
        if isValidArray(GPet.share.nextSelectPets){
            return GPet.share.nextSelectPets as! [String]
        }else{
            BH_WARNING_LOG("next select pets is nil")
            return []
        }
    }
    
    func checkout_confirm_button_hidden(_ pet:Pets?) -> Bool {
        if GPet.share.showPetStatus == .sync{
            if GPet.share.checkPetIsNext(pet){
                return true
            }else{
                return false
            }
        }else{
            if GPet.share.checkPetIsFinsih(pet){
                return false
            }else{
                return true
            }
        }
    }
    
    func checkout_change_pet_switch_hidden() -> Bool{
        let change_pet_feature = GUserConfigUtil.share.checkout_change_pet_feature()
        if change_pet_feature == true{
            let childHasBotleState : ChildPetBottle = GChild.share.checkPetAndBottleWithChild(GUser.share.activeChild)
            if childHasBotleState == .pet{
                return true
            }
            return false
        }else{
            return true
        }
    }
 
    func checkout_add_egg(_ feature: Bool) -> Bool{
        if feature{
            if GPet.share.can_add_pet{
                return true
            }
            if GPet.share.can_add_pet == false && GPet.share.pet_notify_level.floatValue > 0{
                return true
            }
            return false
        }else{
            return false
        }
    }
    
    func check_can_request_pet_switch(_ haveCup: Bool) -> Bool {
        if haveCup {
            return haveCup
        }else{
            GPet.share.can_add_pet = true
            GPet.share.pet_notify_level = NSNumber(value: -1)
            GPet.share.nextSelectPets?.removeAllObjects()
            return false
        }
    }
    
}
