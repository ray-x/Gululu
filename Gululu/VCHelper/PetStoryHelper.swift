//
//  PetStoryHelper.swift
//  Gululu
//
//  Created by baker on 2017/11/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import DOUAudioStreamer

class PetStoryHelper: NSObject {
    
    let OCEAN = "ocean"
    let WOOD = "wood"
    let DESERT = "desert"
    
    static let share = PetStoryHelper()
    
    var ocean_array = [MediaInfo]()
    var wood_array = [MediaInfo]()
    var desert_array = [MediaInfo]()
    
    var ocean_locked = false
    var wood_locked = false
    var desert_locked = false
    
    let small_creature_tag = 101
    
    let play_btn_tag = 102
    let stop_btn_tag = 103
    
    let wifi_view_tag = 104
    let red_sign_tag = 105
    let yellow_sign_tag = 106
    let green_sign_tag = 107
    
    let creature_view_tag = 200
    let ocean_button_tag = 201
    let wood_button_tag = 202
    let desert_button_tag = 203
    let four_button_tag = 204
    let five_button_tag = 205
    var select_button_tag = 201
    
    let scroller_view_tag = 300
    
    var creature_up = false
    var scroller_view_y: CGFloat = 0
    var creature_page = 0
    var page_creature_number = 21
    
    var playing: Bool = false
    var streamer: DOUAudioStreamer?
    var audioVisualizer: DOUAudioAnalyzer?
    var play_timer: DispatchSourceTimer?
    
    var kStatusKVOKey = "kStatusKVOKey"
    var kDurationKVOKey = "kDurationKVOKey"
    var kBufferingRatioKVOKey = "kBufferingRatioKVOKey"
    
    var currentTrackIndex: NSInteger = 1
    
    func get_child_pet_story(_ cloudCallback:@escaping (Bool)-> Void) {
        reset_data()
        let requset = GUHttpRequest()
        requset.setRequestConfig(.get, url: get_pet_story_utl())
        requset.handleRequset(callback: { result in
            if result.boolValue{
                self.handle_pet_story(result.value!)
                cloudCallback(true)
            }else{
                self.read_media_info_value()
                cloudCallback(false)
            }
        })
    }
    
    func get_button_first_origin() -> CGPoint {
        var first_x = CGFloat(20)
        if UIDevice.current.is_iPhoneX(){
            first_x = CGFloat(40)
        }
        let button_y = CGFloat(30)
        return CGPoint(x: first_x, y: button_y)
    }
    
    func get_button_size() -> CGSize {
        let button_origin = get_button_first_origin()
        let buttonWidth = (SCREEN_HEIGHT-4*get_button_middle_width()-2*button_origin.x)/5
        let buttonHeight = buttonWidth/4
        scroller_view_y = buttonHeight + button_origin.y
        return CGSize(width: buttonWidth, height: buttonHeight)
    }
    
    func get_button_middle_width() -> CGFloat {
        return CGFloat(20)
    }
    
    func get_button_origin_x(_ widthInt: Int) -> CGFloat {
        let button_origin = get_button_first_origin()
        let middle_x = get_button_middle_width()
        let button_size  = get_button_size()
        return button_origin.x + CGFloat(widthInt-1)*(button_size.width+middle_x)
    }
    
    func get_creature_size() -> CGSize {
        return CGSize(width: 0.168*SCREEN_WIDTH, height: 0.168*SCREEN_WIDTH)
    }
    
    func get_creature_middle_x() -> CGFloat {
        var first_x = CGFloat(40)
        if UIDevice.current.is_iPhoneX(){
            first_x = CGFloat(60)
        }
        return (SCREEN_HEIGHT - SCREEN_WIDTH*1.176 - 2*first_x)/6
    }
    
    func get_locked_word_num() -> Int {
        var word_num = 1
        if ocean_locked{
           // default 1
        }
        if wood_locked{
            word_num = word_num + 1
        }
        if desert_locked{
            word_num = word_num + 1
        }
        return word_num
    }
    
    func all_creature_lock() -> Int {
        creature_page = get_locked_word_num()
        return (creature_page * page_creature_number) - 1
    }
    
    func reset_data()  {
        ocean_locked = false
        wood_locked = false
        desert_locked = false
        
        ocean_array.removeAll()
        wood_array.removeAll()
        desert_array.removeAll()
    }
    
    func save_pet_story_dic(_ dic: NSDictionary?) {
        guard isValidDic(dic) else {
            return
        }
        let key = pet_story_meida_info_key + activeChildID
        UserDefaults.standard.set(dic, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func read_media_info_value(){
        let key = pet_story_meida_info_key + activeChildID
        let dic: NSDictionary? = UserDefaults.standard.object(forKey: key) as? NSDictionary
        handle_pet_story(dic)
    }
    
    func handle_pet_story(_ dic: NSDictionary?) {
        guard isValidDic(dic) else {
            return
        }
        save_pet_story_dic(dic)
        let word_list: [NSDictionary] = dic!.object(forKey: "media_info") as! [NSDictionary]
        for word_dic in word_list{
            let word_name: String = word_dic.object(forKey: "world_name") as! String
            if word_name == OCEAN{
                (ocean_locked, ocean_array) = handle_media_dics(word_dic)
            }else if word_name == WOOD{
                (wood_locked, wood_array) = handle_media_dics(word_dic)
            }else if word_name == DESERT{
                (desert_locked, desert_array) = handle_media_dics(word_dic)
            }
        }
    }
    
    func handle_media_dics(_ word_dic: NSDictionary) -> (Bool, [MediaInfo]) {
        var array =  [MediaInfo]()
        let ocean_creature: [NSDictionary] = word_dic.object(forKey: "world_creature") as! [NSDictionary]
        let lock = word_dic.object(forKey: "world_lock") as! Bool
        for mediaDic: NSDictionary in ocean_creature{
            var ocean_media = MediaInfo()
            ocean_media.media_avatar = mediaDic.object(forKey: "media_avatar") as? String
            ocean_media.tag = mediaDic.object(forKey: "media_tag") as? String
            ocean_media.media_name = mediaDic.object(forKey: "media_name") as? String
            ocean_media.bionts_status = mediaDic.object(forKey: "bionts_status") as? Int
            ocean_media.url = mediaDic.object(forKey: "media_url") as? String
            ocean_media.thumb_url = mediaDic.object(forKey: "media_thumbnail_url") as? String
            array.append(ocean_media)
        }
        return (lock, array)
    }
    
    func creature_is_locked(_ tag: Int) -> Bool {
        if tag > get_all_lock_creature_numbers(){
            return false
        }else{
            let media_info = get_click_media_info(tag)
            if media_info.bionts_status == 0 || media_info.bionts_status == nil{
                return false
            }else{
                return true
            }
        }
    }
    
    func get_click_media_info(_ trueTag: Int) -> MediaInfo {
        if trueTag <= ocean_array.count{
            return ocean_array[trueTag-1]
        }else if trueTag > ocean_array.count && trueTag <= wood_array.count + ocean_array.count{
            let wood_tag = trueTag - ocean_array.count
            return wood_array[wood_tag-1]
        }else if trueTag > wood_array.count + ocean_array.count && trueTag <= wood_array.count + ocean_array.count + desert_array.count{
            let desert_tag = trueTag - wood_array.count - ocean_array.count
            return desert_array[desert_tag-1]
        }else{
            return MediaInfo()
        }
    }
    
    func click_media_info_can_play(_ trueTag: Int) -> Bool {
        let media_info = get_click_media_info(trueTag)
        return isValidString(media_info.url)
    }
    
    
    func get_all_lock_creature_numbers() -> Int {
        return ocean_array.count + wood_array.count + desert_array.count
    }
    
    func get_current_Track(_ mediaInfo: MediaInfo) -> Track {
        let track = Track()
        track.audioFileUrl = (mediaInfo.url)!
        return track
    }
    
    func can_show_pet_story_enter() -> Bool {
        if Common.checkPreferredLanguagesIsEn(){
            return false
        }
        if !GChild.share.check_current_child_have_cup(){
            return false
        }
        if GUserConfigUtil.share.checkout_pet_story_feature(){
            return true
        }
        return false
    }
    
}
