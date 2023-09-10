//
//  RecommendWaterHelper.swift
//  Gululu
//
//  Created by Baker on 17/8/16.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

struct RecommendRateInfo {
    var info : String?
    var rate : Float?
    init(_ info : String?, rate : Float?) {
        self.info = info
        self.rate = rate
    }
}

class RecommendWaterHelper: BaseHelper {
    
    static let share = RecommendWaterHelper()
    var rate_array = [RecommendRateInfo]()
    var drinkPer : Int = 0
    var choseRateInfo = RecommendRateInfo("", rate: 1.0)
    var currentRateInfo = RecommendRateInfo("", rate: 1.0)
    
    func get_child_recommend_water_rate_list(_ cloudCallback:@escaping (Bool)->Void) {

        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:get_recommend_list_url)
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                cloudCallback(self.setRateArrayFromArray(self.handleResult(dic)))
            }else{
                cloudCallback(false)
//                cloudCallback(self.setRateArrayFromArray(self.readDicFormDefault()))
            }
        })
    }
    
    func setRateArrayFromArray(_ array : [RecommendRateInfo]?) -> Bool{
        if isValidArray(array as NSArray?){
            rate_array.removeAll()
            for newItem in array! {
                rate_array.append(newItem)
                rate_array = sortArray(rate_array)
            }
            setCurrentRateInfo(GUser.share.activeChild)
            return true
        }
        return false
    }
    
    func handleResult(_ dic : NSDictionary?) -> [RecommendRateInfo]{
        if dic == nil || dic?.count == 0{
            return [RecommendRateInfo]()
        }
        let status : String? = dic?["status"] as? String
        if status == "OK"{
            let remote_array : [NSDictionary]? = dic?["recommend_water_rate"] as! [NSDictionary]?
            saveInfo(remote_array as NSObject?, saveKey: childRecommendRateInfoKey)
            return handleRemoteArray(remote_array)
        }else{
            return readDicFormDefault()
        }
    }
    
    func handleRemoteArray(_ array : [NSDictionary]?) ->  [RecommendRateInfo]{
        
        var return_array = [RecommendRateInfo]()
        
        if array == nil || array?.count == 0 {
            return return_array
        }
        for dic : NSDictionary in array!{
            var Item : RecommendRateInfo = RecommendRateInfo("", rate: 0.0)
            Item.info = dic.object(forKey: "info") as? String
            let rate : Double? = dic.object(forKey: "rate") as? Double
            Item.rate = Float(rate!)
            return_array.append(Item)
        }
        rate_array = sortArray(return_array)
        return rate_array
    }
    
    func sortArray(_ array : [RecommendRateInfo]) -> [RecommendRateInfo]{
         let resultArray = array.sorted { (recommendinfo1, recommendinfo2) -> Bool in
            return recommendinfo1.rate < recommendinfo2.rate
        }
        return resultArray
    }
    
    func readDicFormDefault() -> [RecommendRateInfo]{
        let savekey = activeChildID + childRecommendRateInfoKey
        let vedioArray : [NSDictionary]? = UserDefaults.standard.object(forKey: savekey) as? [NSDictionary]
        if vedioArray?.count == 0 || vedioArray == nil{
            return [RecommendRateInfo]()
        }
        let mediaArray : [RecommendRateInfo] = handleRemoteArray(vedioArray!)
        if mediaArray.count == 0{
            return [RecommendRateInfo]()
        }
        return mediaArray
    }
    
    func put_child_recommend_water_rate(_ chose_rate:Float?, cloudCallback:@escaping (Bool)->Void) {
        GUser.share.activeChild?.water_rate = chose_rate as NSNumber?
        GChildRequsetUtil.updateChilren { (result) in
            cloudCallback (result)
        }
    }
    
    func getDetailInfoFrom_rate(_ drinkPer : Float) -> String {
        if isValidArray(rate_array as NSArray?){
            for rateInfo in rate_array {
                if rateInfo.rate == drinkPer{
                    return rateInfo.info!
                }
            }
            return ""
        }
        return ""
    }
    
    func is_need_to_upload_rate() -> Bool {
        if choseRateInfo.rate == currentRateInfo.rate{
            return false
        }
        return true
    }
    
    func setCurrentRateInfo(_ child : Children?) {
        if isValidString(child?.childID){
            if child?.water_rate == 0{
                child?.water_rate = 1
            }
            currentRateInfo.rate = child?.water_rate as! Float?
            currentRateInfo.info = getDetailInfoFrom_rate(child?.water_rate! as! Float)
            
            if checkCurrentRateInfoIsExistInList(){
                choseRateInfo.info = currentRateInfo.info
                choseRateInfo.rate = currentRateInfo.rate
            }
        }
    }

    func checkCurrentRateInfoIsExistInList() -> Bool {
        guard rate_array.count != 0 else {
            return false
        }
        for rate_info in rate_array {
            if rate_info.rate == currentRateInfo.rate{
                return true
            }
        }
        return false
    }

    func add_water_rate() {
        guard rate_array.count != 0 else {
            return
        }
        for index in 0...rate_array.count-1{
            let recommendRate = rate_array[index]
            if recommendRate.rate > choseRateInfo.rate{
                choseRateInfo.rate = recommendRate.rate
                choseRateInfo.info = recommendRate.info
                return
            }
        }
    }
    
    func cut_water_rate() {
        guard rate_array.count != 0 else {
            return
        }
        for index in (0...rate_array.count-1).reversed(){
            let recommendRate = rate_array[index]
            if recommendRate.rate < choseRateInfo.rate{
                choseRateInfo.rate = recommendRate.rate
                choseRateInfo.info = recommendRate.info
                return
            }
        }
    }
    
    func checkAddButtonEnable() -> Bool {
        let bigRateInfo = rate_array.last
        if bigRateInfo?.rate > choseRateInfo.rate{
            return true
        }
        return false
    }
    
    func checkCutButtonEnable() -> Bool {
        let littleRateInfo = rate_array.first
        if littleRateInfo?.rate < choseRateInfo.rate{
            return true
        }
        return false
    }
    
    func getChoseRateRecommendWaterLabelStr(_ unit : String?) -> String {
        let waterValue = GChild.share.getActiveChildBaseRecommentWater()
        let unitStr = GChild.share.getChildUnitDayStr()
        let choseWaterStr = Int(choseRateInfo.rate! * 100000) * waterValue
        
        let lastchoseWaterStr = GChild.share.changeRecommendWater(Int(choseWaterStr/100000), unitStr: unit)
        return String(format: "%d %@", lastchoseWaterStr,unitStr)
    }
    
    func countChildAge(_ birthday : String?) -> String{
        let child_bir_date = BKDateTime.getDateFromStr("yyyy-MM-dd",dateStr: getBirthdayFormat(birthday))
        let child_age_info = BKDateTime.ageWithDateOfBirth(date: child_bir_date)
        return String(format:"%d %@", child_age_info.0,child_age_info.1)
    }
    
    func countChildWeight() ->  String{
        return String(format:"%d %@",GChild.share.getChildWeight(), GChild.share.getChildWightUnitStr())
    }
    
    func getBirthdayFormat(_ birthday : String?) -> String {
        if !isValidString(birthday){
            return ""
        }
        if birthday!.count > 10{
            return birthday!.substring(to: (birthday!.index(birthday!.startIndex, offsetBy: 10)))
        }
        return birthday!
    }

}
