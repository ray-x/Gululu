//
//  ShareScoreHelper.swift
//  Gululu
//
//  Created by Gululu on 2017/11/15.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class ShareScoreHelper: NSObject {

    static let share = ShareScoreHelper()
    
    func get_share_day_all_image() -> (String, String, String, UIColor, UIColor, UIColor) {
        
        var bg_image_string: String
        var bg_little_image_string: String
        var title_bg_image_string: String
        var banner_color: UIColor
        var default_banner_color: UIColor
        var bottom_btn_bg_color: UIColor
        
        if BKDateTime.checkoutChristmasDay(Date()){
            bg_image_string = "main_share_christmas_bg"
            bg_little_image_string = "main_share_christmas_little_bg"
            title_bg_image_string = "main_share_christmas_title_bg"
            banner_color = .white
            default_banner_color = RGB_COLOR(97, g: 18, b: 36, alpha: 1)
            bottom_btn_bg_color = RGB_COLOR(255, g: 125, b: 109, alpha: 0.25)
        }else if BKDateTime.checkoutSpringFestvialDay(Date()){
            bg_image_string = "main_share_spring_bg"
            bg_little_image_string = "main_share_spring_little_bg"
            title_bg_image_string = "main_share_score_title_img"
            banner_color = RGB_COLOR(250, g: 225, b: 90, alpha: 1)
            default_banner_color = RGB_COLOR(97, g: 18, b: 36, alpha: 1)
            bottom_btn_bg_color = RGB_COLOR(255, g: 125, b: 109, alpha: 0.25)
        }else{
            bg_image_string = "main_share_score_bg"
            bg_little_image_string = "main_share_score_little_bg"
            title_bg_image_string = "main_share_score_title_img"
            banner_color = RGB_COLOR(74, g: 255, b: 240, alpha: 1)
            default_banner_color = RGB_COLOR(22, g: 76, b: 99, alpha: 1)
            bottom_btn_bg_color = RGB_COLOR(74, g: 255, b: 240, alpha: 0.25)
        }
        return (bg_image_string, bg_little_image_string, title_bg_image_string, banner_color, default_banner_color, bottom_btn_bg_color)
    }
    
    func get_share_pet_img_name() -> String {
        var numInt = Int(arc4random()%6)
        if numInt == 0{
            numInt = 1
        }
        var strNumInt = ""
        let petName = GPet.share.getActivePetName()
        let petLittleName = petName.lowercased()
        var pet_img_str: String
        if BKDateTime.checkoutChristmasDay(Date()){
            strNumInt = "1225"
        }else if BKDateTime.checkoutSpringFestvialDay(Date()){
            strNumInt = "0101"
        }else{
            strNumInt = String(numInt)
        }
        
        pet_img_str = String(format:"main_score_share_%@%@",petLittleName,strNumInt)
        return pet_img_str
    }
    
    func get_share_bottom_img() -> String {
        if Common.checkPreferredLanguages() == 2{
            return "main_score_share_title_zhn"
        }else if Common.checkPreferredLanguages() == 1{
            return "main_score_share_title_zn"
        }else{
            return "main_score_share_title_en"
        }
    }
    
    func get_share_title_img_and_info(_ defauletValue: Int) -> (String, String) {
        var image = String()
        var info = String()
        let rate = Int(Double(defauletValue - 60) * 2.5)
        if defauletValue == 60{
            image = "main_share_oops"
            info = Localizaed("We miss you badly, come back and drink.")
        }else if defauletValue > 60 && defauletValue <= 69{
            image = "main_share_oops"
            info = String(format: Localizaed("You beat %d %% of the other Gululu users! Every single sip matters for the Gululu uninverse."),rate)
        }else if defauletValue >= 70 && defauletValue <= 79{
            image = "main_share_goodjob"
            info = String(format:Localizaed("Well done! You beat %d %% of the other Gululu users from all over the world! Keep drinking and keep healthy!"),rate)
        }else if defauletValue >= 80 && defauletValue <= 89{
            image = "main_share_rock"
            info = String(format:Localizaed("Super fan of Gululu? Ah-ha, You beat %d %% of the other Gululu users, are you ready for new challenges?"),rate)
        }else if defauletValue >= 90 && defauletValue <= 99{
            image = "main_share_superstar"
            info = String(format:Localizaed("You beat %d %% of the other Gululu users! Mommy will never be worried about your water drinking!"),rate)
        }else if defauletValue == 100{
            image = "main_share_legend"
            info = Localizaed("Wow amazing job drinking water and using Gululu! Drinking water is something fabulous in your life!!")
        }else{
            image = "main_share_oops"
            info = Localizaed("We miss you badly, come back and drink.")
        }
        return (image, info)
    }
}
