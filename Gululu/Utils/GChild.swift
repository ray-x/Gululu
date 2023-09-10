//
//  GChild.swift
//  Gululu
//
//  Created by Baker on 17/3/10.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

enum ChildPetBottle: Int{
    case none   = 0
    case pet
    case both
}

var activeChildID: String = ""

class GChild: NSObject {
    
    static let share  = GChild()
    
    var drinkWaterDayArray    = [Int]()
    var drinkWaterHourArray   = [Int]()
    
    var lastDrinkUpdate : Date = Date()
    let defaultRecommendValue : Float = 960
    
    func getActiveChildID() -> String {
        if isValidString(activeChildID){
            return activeChildID
        }
        if isValidString(GUser.share.activeChild?.childID){
            return (GUser.share.activeChild?.childID)!
        }else{
            let childid = GUser.share.readActiveChildID()
            if isValidString(childid){
                return childid!
            }else{
                return "0"
            }
        }
    }
    
    func updateChild()  {
        let child:Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return
        }
        child!.update(.fetch, uiCallback: { _ in })
    }
        
    func deleteChildFromNet(_ cloudCallback:@escaping (Bool) -> Void) {
        let children : Children? = createObject(Children.self, objectID: activeChildID)
        guard children != nil else {
            cloudCallback(false)
            return
        }
        children?.remove(uiCallback: { result in
            cloudCallback(result.boolValue)
        })
    }
    
    func readChildListFromDB() -> [Children]? {
        let childListFromData:[Children]? = createObjects(Children.self) as? [Children]
        guard childListFromData != nil else {
            return [Children]()
        }
        return childListFromData!
    }
    
    func isHaveChild() -> Bool {
        let childListFromData:[Children]? = readChildListFromDB()
        let child = childListFromData?.first
        guard child?.childID != nil else {
            return false
        }
        return true
    }
    
    func syncChild(_ dic : NSDictionary,handleObject : NSObject) {

        let childListFromData:[Children]? = readChildListFromDB()
        
        guard childListFromData?.count != 0 else {
            return
        }

        if cloudObj().getOperationFromObject(handleObject) == .fetchAll{
            for i in 0...(childListFromData?.count)!-1 {
                let child = childListFromData?[i]
                backgroundMoc?.delete(child!)
            }
        }else{
            for i in 0...(childListFromData?.count)!-1 {
                let child = childListFromData?[i]
                if child?.childID == nil {
                    backgroundMoc?.delete(child!)
                }
            }
        }
        saveContext()
    }
    
    func childIsHaveCup() -> Bool {
        let child : Children? = createObject(Children.self, objectID: activeChildID)
        guard child?.childID != nil else {
            return false
        }
        if child?.hasCup == 1 {
            return true
        }else{
            return false
        }
    }
    
    func childIsHaveCupFromChild(_ child : Children) -> Bool {
        guard child.childID != nil else {
            return false
        }
        if child.hasCup == 1 {
            return true
        }else{
            return false
        }
    }
    
    func deleteAllChildIfSame(childID:String?) {
        if childID == ""{
            return
        }else{
            let childListFromData:[Children]? = readChildListFromDB()
            for i in 0...(childListFromData?.count)!-1 {
                let child = childListFromData?[i]
                if child?.childID == childID {
                    backgroundMoc?.delete(child!)
                }
            }
            saveContext()
        }
    }
    
    func checkHabitResult(result : Int) -> Int {
        var str : Int = 0
        if result > 100{
            str = 100
        }
        if result < 60 {
           str = 60
        }
        str = result
        saveHabitIndex(str)
        return str
    }
    
    //saveHabitex
    func saveHabitIndex(_ habitScore : Int) {
        let key = habitIndexKey.appending(activeChildID)
        UserDefaults.standard.set(habitScore, forKey: key)
    }
    
    func readHabitIndex() -> Int {
        let key = habitIndexKey.appending(activeChildID)
        let myHabitx = UserDefaults.standard.object(forKey: key) as! Int?
        if myHabitx == nil{
            return 60
        }
        if myHabitx > 100{
            return 100
        }
        if myHabitx < 60 {
            return 60
        }
        return myHabitx!
    }

    func handleWaterPer(_ per:Float?) -> Float {
        var perStr = per
        if perStr <= 0.05 {
            perStr = 0.05
        }else if perStr >= 0.98 {
            perStr = 0.98
        }
        return perStr!
    }
    
    func handleHourDayToPer(_ daydrinkAllWater:Int?) -> Float{
        guard GUser.share.activeChild?.unit != nil else {
            return 0
        }
        let allper = getActiveChildRecommentWater(GUser.share.activeChild?.unit)
        let day_drink_true_water = changeRecommendWater(daydrinkAllWater, unitStr: GUser.share.activeChild?.unit)
        var perInData : Float = Float(day_drink_true_water) / Float(allper)
        if perInData >= 1{
            perInData = 1
        }
        return perInData
    }
    
    func saveDrinkHourData(_ daydrinkAllWater:Int?) {
        let key1 = activeChildID + drinkHourAllDataKey
        let key2 = activeChildID + drinkHourDataArrayKey
        UserDefaults.standard.set(daydrinkAllWater!, forKey: key1)
        UserDefaults.standard.set(drinkWaterHourArray, forKey: key2)
        UserDefaults.standard.synchronize()
    }
    
    func saveDrinkDayData() {
        let key3 = activeChildID + drinkDayDataArrayKey
        UserDefaults.standard.set(drinkWaterDayArray, forKey: key3)
        UserDefaults.standard.synchronize()
    }
    
    func readDrinkHourData() -> Int {
        let key1 = activeChildID + drinkHourAllDataKey
        let key2 = activeChildID + drinkHourDataArrayKey
        let hourData : [Int]? = UserDefaults.standard.object(forKey: key2) as! [Int]?
        if hourData?.count == 0 || hourData == nil{
            drinkWaterDayArray = [0,0,0,0,0,0,0]
        }else{
            drinkWaterDayArray = hourData!
        }
        
        var allDrinkDayData : Int? = UserDefaults.standard.object(forKey: key1) as! Int?
        if allDrinkDayData == nil{
            allDrinkDayData = 0
            return 0
        }else{
            return allDrinkDayData!
        }
    }
    
    func readChildDrinkHourData(_ child : Children) -> Int {
        guard child.childID != nil else {
            return 0
        }
        let key = child.childID! + drinkHourAllDataKey
        let allDrinkDayData : Int? = UserDefaults.standard.object(forKey: key) as! Int?
        if allDrinkDayData == nil{
             return 0
        }else{
             return allDrinkDayData!
        }
    }
    
    func readDrinkDayData(){
        let key3 = activeChildID + drinkDayDataArrayKey
        let dayData : [Int]? = UserDefaults.standard.object(forKey: key3) as! [Int]?
        if dayData?.count == 0 || dayData == nil{
            drinkWaterDayArray = [0,0,0,0,0,0,0]
        }else{
           drinkWaterDayArray = dayData!
        }
    }
    
    func check_current_child_have_cup() -> Bool {
        guard GUser.share.activeChild?.childID != nil else {
            return false
        }
        if GUser.share.activeChild!.hasCup == 1{
            return true
        }
        return false
    }
    
    func checkPetAndBottleWithChild(_ child: Children?) -> ChildPetBottle{
        guard child?.childID != nil else {
            return .none
        }
        if child!.hasPet == 1{
            if child!.hasCup == 1{
                return .both
            }else{
                return .pet
            }
        }
        return .none
    }
    
    func getMainViewUnitStr(_ daydrinkAllWater:Int ) -> String{
        let per =  handleHourDayToPer(daydrinkAllWater)
        if per == 1.00 {
            return Localizaed("Wow! Goal achieved!")
        }else{
            if !isValidString(GUser.share.activeChild?.unit){
                GUser.share.activeChild?.unit = "kg"
            }
            let recommendValue = getActiveChildRecommentWater(GUser.share.activeChild?.unit)
            let day_drink_true_water = changeRecommendWater(daydrinkAllWater, unitStr: GUser.share.activeChild?.unit)
            return String(format: Localizaed("%d of %d %@"),day_drink_true_water,recommendValue,getChildUnitStr())
        }
    }
    
    func getDayDrinkWater() -> String {
        
        if GUser.share.activeChild == nil || GUser.share.activeChild?.recommendWater == nil{
            return "10\rml"
        }
        
        let recommednVallue = getActiveChildRecommentWater(GUser.share.activeChild?.unit)
        let unitStrValue = getChildUnitStr()
        
        if GUser.share.activeChild?.unit == "lbs"{
            return "\(getDayDrinkHourWater_lbs(recommednVallue))\r\(unitStrValue)"
        }
        return "\(getDayDrinkHourWater_ml(recommednVallue))\r\(unitStrValue)"
      
    }
    
    func getDayDrinkHourWater_ml(_ recommendValue : Int?) -> Int {
        if recommendValue == 0 || recommendValue == nil{
            return 0
        }
        return (Int(Float((recommendValue)!)/7+5))/10*10
    }
    
    func getDayDrinkHourWater_lbs(_ recommendValue : Int?) -> Int {
        return recommendValue!/7
    }
    
    func waterUnitMlTrunOz(_ ozVlaue : Int) -> Int {
        return Int(Double(ozVlaue)*0.033814)
    }
    
    func getWeekDrinkWater() -> String {
        let unit = getChildUnitStr()
        let recommentValue = getActiveChildRecommentWater(GUser.share.activeChild!.unit)
        return String(format:"%d\r%@",recommentValue, unit)
    }

    func getActiveChildName() -> String {
        guard GUser.share.activeChild?.childName != nil else {
            return Localizaed("Child's Name")
        }
        return (GUser.share.activeChild?.childName)!
    }
    
    func getActiveChildRecommentWater(_ unit : String?) -> Int {
        var unitStr = unit
        var intWaterRate : Float?
        var recommendValue : Float?
        if !isValidString(unit){
            unitStr = "kg"
        }
        if !isValidString(GUser.share.activeChild?.recommendWater?.stringValue) || GUser.share.activeChild?.recommendWater?.intValue == 0{
            recommendValue = 0
        }else{
            recommendValue = GUser.share.activeChild?.recommendWater?.floatValue
        }

        if GUser.share.activeChild?.water_rate == nil || GUser.share.activeChild?.water_rate?.floatValue == 0{
            intWaterRate = 100000
        }else{
            intWaterRate = (GUser.share.activeChild?.water_rate?.floatValue)! * 100000
        }
        recommendValue = recommendValue! * intWaterRate!

        return changeRecommendWater(Int(recommendValue!/100000), unitStr: unitStr)
    }
    
    func getActiveChildBaseRecommentWater() -> Int {
        if !isValidString(GUser.share.activeChild?.recommendWater?.stringValue){
            return Int(defaultRecommendValue)
        }
        return GUser.share.activeChild?.recommendWater as! Int
    }
    
    func changeRecommendWater(_ recommendValue : Int?, unitStr : String?) -> Int {
        if recommendValue == nil || recommendValue == 0{
            return kgTurnKg(Int(0))
        }
        if !isValidString(unitStr){
            return kgTurnKg(recommendValue)
        }
        if unitStr == "kg"{
            return kgTurnKg(recommendValue)
        }else{
            return kgTurnLbs(recommendValue)
        }
    }
    
    func kgTurnKg(_ recommedIntValue:Int?) -> Int {
        if recommedIntValue != nil{
            return (recommedIntValue!+5)/10*10
        }
        return Int(0)
    }
    
    func kgTurnLbs(_ recommedIntValue:Int?) -> Int {
        if recommedIntValue != nil{
            return waterUnitMlTrunOz(recommedIntValue!)
        }
        return waterUnitMlTrunOz(Int(0))
    }

    func getChildUnitStr() -> String {
        if getChildWightUnitStr() == "lbs" {
            return Localizaed("oz")
        }
        return Localizaed("ml")
    }
    
    func getChildWeight() -> Int {
        if GUser.share.activeChild?.weight?.doubleValue == 0 || GUser.share.activeChild?.weight == nil{
            return 25
        }
        if getChildWightUnitStr() == "kg"{
            return GUser.share.activeChild?.weight as! Int
        }
        return GUser.share.activeChild?.weightLbs as! Int
    }
    
    func getChildWightUnitStr() -> String {
        if !isValidString(GUser.share.activeChild?.unit){
            return "kg"
        }
        return (GUser.share.activeChild?.unit)!
    }
    
    func getChildUnitDayStr() -> String {
        if GUser.share.activeChild?.unit == "lbs" {
            return Localizaed("oz/day")
        }
        return Localizaed("ml/day")
    }
    

    
}
