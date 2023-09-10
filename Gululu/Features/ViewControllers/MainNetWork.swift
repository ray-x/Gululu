//
//  MainNetWork.swift
//  Gululu
//
//  Created by Baker on 16/8/29.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import Foundation

extension MainVC {
    
    func displayCurrentPet() {
        checkNetIsNeedShowRedSign()
        GPet.share.displayCurrentPet {
            DispatchQueue.main.async {
                self.showPetDarase()
                switch GPet.share.showPetStatus{
                case .noPet:
                    self.loadNoPet()
                    break
                case .active:
                    self.loadActivePet()
                    break
                case .change:
                    self.loadChangePet()
                    break
                case .sync:
                    self.loadNewSynPetRotationImageView()
                    break
                case .byeBye:
                    self.loadSayGoodByeToOldPet()
                    break
                default :
                    break
                }
            }
        }
    }
    
    func getChildPhotoURL() -> Void {
        if !Common.checkInternetConnection(){
            checkNetIsNeedShowRedSign()
            updateChildAvatar()
        }
        AvatorHelper.share.getChildProfileFromServer(activeChildID,uiCallback: { result in
            DispatchQueue.main.async { 
                self.updateChildAvatar()
            }
        })
    }
    
    func updateHabites() {
        checkNetIsNeedShowRedSign()
        GChild.share.getHabitex({ result in
            DispatchQueue.main.async(execute: {
                self.habit_score_button.setTitle(String(format: "%d", result), for: .normal)
            })
        })
    }
    
    func dayDrinkWaterLog() -> Void {
        checkNetIsNeedShowRedSign()
        GChild.share.getHourDrinkLog { dayDrink in
            DispatchQueue.main.async {
                let per = GChild.share.handleHourDayToPer(dayDrink)
                self.setViewVoulButtonStyle(per: per)
                self.setUnitLabelText(GChild.share.getMainViewUnitStr(dayDrink))
                if (self.waterBarView != nil) {
                    self.waterBarView!.intakeHourInDay = GChild.share.drinkWaterHourArray
                }
                self.loadWaterBgImageView(per)
            }
        }
    }
    
    func weekDrinkWaterLog() -> Void {
        checkNetIsNeedShowRedSign()
        GChild.share.getDayDrinkLog({ 
            DispatchQueue.main.async {
                if self.waterBarView != nil{
                    self.waterBarView!.intakeDayInWeek = GChild.share.drinkWaterDayArray
                }
            }
        })
    }
    
    func setViewVoulButtonStyle(per:Float?) {
        if let perDecode = per{
            let strper = String(format: "%.0f",perDecode * 100)
            viewVolButton.setTitle("\(strper)%", for: .normal)
        }
        viewVolButton.setleftImage(5.0)
    }
    
    func getAPIVersion() {
        checkNetIsNeedShowRedSign()
        GVersion.share.getApiVersion {
            DispatchQueue.main.sync {
                if GVersion.share.isForceUpdate {
                    self.showForceUpdate()
                }
                if GVersion.share.isUpdate{
                    self.showUpdate()
                }
            }
        }
    }
    
    func showPetDarase() {
        let iscanshowParadise = GPet.share.localHavePet()
        petButton.isEnabled = iscanshowParadise
        if iscanshowParadise == false{
            petButton.setTitleColor(RGB_COLOR(255, g: 255, b: 255, alpha: 0.5), for: .normal)
        }else{
            petButton.setTitleColor(RGB_COLOR(255, g: 255, b: 255, alpha: 1), for: .normal)
        }
    }
    
    func get_child_pet_cup_level() {
        if !isConnectNet(){
            let resultInt = GCup.share.read_child_pet_cup_level()
            set_child_pet_cup_level_text(resultInt)
            return
        }
        GCup.share.get_child_pet_cup_level { (resultInt) in
            DispatchQueue.main.sync {
                self.set_child_pet_cup_level_text(resultInt)
            }
        }
    }
    
    func set_child_pet_cup_level_text(_ resultInt: Int)  {
        if resultInt == -1{
            child_pet_cup_level.isHidden = true
            child_name_height.constant = 1.0
        }else{
            child_pet_cup_level.isHidden = false
            child_name_height.constant = 0.8
            child_pet_cup_level.text = "LV " + String(resultInt)
        }
    }
    
}
