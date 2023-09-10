//
//  API.swift
//  Gululu
//
//  Created by Baker on 17/8/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

let child = "/m/child/"
let cup = "/m/cup/"
let getChildPetOptions = "/pet_options"
let getchildPlants = "/m/game/child/"
let gameVersion = "/game_version"
let game1 = "/game_ep1_backhome"
let game2 = "/game_ep2_saveIma"
let featureConfigUrl = "/m/feature_config"
let health_feature_url = "/m/health"

let getPetsUrl = child + "pets"
let getUserVedioUrl = "/m/media/videos"
let checkUserAccountUrl = "/m/account"
let getPhoneCodeUrl = "/m/phone/verify_code"
let checkPhoneCodeUrl = "/m/phone/verify_code"
let loginUrl = "/m/user/login"
let resetPasswordUrl = "/m/user/phone/password"
let sendAvtiveEmail = "/m/user/confirm_email"
let get_recommend_list_url = "/m/recommended_water_rate"
let checkUpgradePetStatusUrl = "/m/cup_upgrade_status"
let setTimeZoneUrl = "/m/child/timezone"
let gethabitScoreUrl  = "/m/child/habit-score"
let getDrinkLogsUrl = "/m/child/drinking-logs"
let avatarUrl = "/m/child/profile"
let get_child_friend = "/m/child/friends"

func getAvatarListUrl() -> String {
    return "/m/user/" + GUser.share.getUserSn() + "/avatars"
}

func postChildAvatarUrl() -> String {
    return "/m/user/" + GUser.share.getUserSn() +  "/child/" + activeChildID + "/avatar"
}

func getnextPetOptionUrl() -> String {
    return "/m/game" + game2 + "/user/" + GUser.share.getUserSn() +  "/child/" + activeChildID + "/pet_types"
}

func getpetUrl() -> String{
    return "/m/game" + game2 + "/user/" + GUser.share.getUserSn() + "/child/" + activeChildID + "/pet"
}

func getpetOptionUrl() -> String {
    return "/m/game" + game2 + "/pet_types"
}

func getChildPlantUrl() -> String {
    return getchildPlants + activeChildID + gameVersion + game1 + "/assets"
}

func getCupGameVersionUrl() -> String {
    return child + activeChildID + gameVersion
}

func getDeviceInfoUrl(_ cupId : String?) -> String {
    guard cupId != "" else {
        return cup + "/info/version"
    }
    return cup + cupId! + "/info/version"
}

func getCupStatusUrl(_ cupId : String?) -> String {
    guard cupId != "" else {
        return cup + "/connect/status"
    }
    return cup + cupId! + "/connect/status"
}

func get_search_friend_url(_ userAccount: String) -> String {
    return "/m/user/" + userAccount + "/children/relation_to/" + activeChildID
}

func get_post_a_pending_friend_url() -> String{
    
    return "/m/user/" + GUser.share.getUserSn() + "/child/" + activeChildID + "/pending_friend_by_request_child"
}

func get_query_pending_friends_url() -> String {
    return "/m/user/" + GUser.share.getUserSn() + "/child/" + activeChildID + "/pending_friends_by_target_child"
}

func get_handle_pending_friend_url() -> String {
    return "/m/user/" + GUser.share.getUserSn() + "/child/" + activeChildID + "/pending_friend_by_target_child"
}

func get_pet_story_utl() -> String {
    return "/m/child/" + activeChildID + "/media/audio/story"
}

func get_child_cup_pet_level() -> String {
    return "/m/game" + game2 + "/user/" + GUser.share.getUserSn() + "/child/" + activeChildID + "/child_level"
}

