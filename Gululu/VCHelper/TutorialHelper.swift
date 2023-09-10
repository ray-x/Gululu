//
//  TutorialHelper.swift
//  Gululu
//
//  Created by Baker on 17/6/29.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

enum enterVCType {
    case pairMainVcIn
    case settingVcIn
    case defaultVc
}

struct MediaInfo {
    var title : String?
    var tag : String?
    var url : String?
    var thumb_url : String?
    var bionts_status: Int?
    var media_avatar: String?
    var media_name: String?
    
    init() {}
}

class TutorialHelper: BaseHelper {
    
    static let share = TutorialHelper()
    var clickUrl : URL?
    var enterType : enterVCType = .defaultVc
    
    func getUserVedio(_ cloudCallback:@escaping ([MediaInfo])->Void) {
        
        if !Common.checkInternetConnection() {
            cloudCallback(readDicFormDefault())
        }
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url: getUserVedioUrl)
        requets.handleRequset(callback: { result in
            if result.boolValue{
                let dic : NSDictionary = result.value!
                let vedioArray : [MediaInfo] = self.handleResult(dic)
                cloudCallback(vedioArray)
            }else{
                cloudCallback(self.readDicFormDefault())
            }
        })
    }
    
    func handleResult(_ dic : NSDictionary) -> [MediaInfo] {
        let status : String? = dic["status"] as? String
        if status == "OK"{
            let vedioArray : [NSDictionary]? = dic["media_info"] as! [NSDictionary]?
            saveInfo(vedioArray! as NSObject?, saveKey: medioVedioDicKey)
            return handleVedioArray(vedioArray!)
        }else{
            return readDicFormDefault()
        }
    }
    
    func handleVedioArray(_ vedioArray : [NSDictionary]?) -> [MediaInfo] {
        var mediaArray = [MediaInfo]()

        guard vedioArray != nil else {
            return mediaArray
        }

        if vedioArray?.count == 0{
            return mediaArray
        }
        for mediaDic : NSDictionary in vedioArray!{
            var mediaItem = MediaInfo()
            mediaItem.title = mediaDic.object(forKey: "media_title") as? String
            mediaItem.tag = mediaDic.object(forKey: "media_tag") as? String
            mediaItem.url = mediaDic.object(forKey: "media_url") as? String
            mediaItem.thumb_url = mediaDic.object(forKey: "media_thumbnail_url") as? String
            
            mediaArray.append(mediaItem)
        }
        return mediaArray
    }

    func readDicFormDefault() -> [MediaInfo] {
        let saveMediaVedioKey = activeChildID + medioVedioDicKey
        let vedioArray : [NSDictionary]? = UserDefaults.standard.object(forKey: saveMediaVedioKey) as? [NSDictionary]
        if vedioArray?.count == 0 || vedioArray == nil{
            return [MediaInfo]()
        }
        let mediaArray : [MediaInfo] = handleVedioArray(vedioArray)
        if mediaArray.count == 0{
            return [MediaInfo]()
        }
        return mediaArray
    }
    
    func getBgPetImageName() -> String {
        let activePetName = GPet.share.getActivePetName()
        return "T" + activePetName
    }
    
    func getTutorialTitle() -> String {
        let titleStr = String(format: Localizaed("    Hi, %@! \r\n    Did you know..."),GChild.share.getActiveChildName())
        return titleStr
    }
    
    func getTutorialButtonBgImageName() -> String {
        let activePetName = GPet.share.getActivePetName()
        return "btn" + activePetName
    }
    
    func uplodeUserIsHandleView(_ handled : Bool) {
        if enterType == .pairMainVcIn{
            if handled {
                return
            }
            //Flurry.logEvent("close_without_click")
        }
    }
    
    
}
