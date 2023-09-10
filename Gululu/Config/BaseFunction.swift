//
//  Base.swift
//  Gululu
//
//  Created by Baker on 17/3/1.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
/** Screen size */
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let BASE_FRAME = UIScreen.main.bounds

let BASEFONT = "Aller"

let BASEBOLDFONT = "Aller-Bold"

// fit screen width
func FIT_SCREEN_WIDTH(_ size: CGFloat) -> CGFloat {
    return size * SCREEN_WIDTH / 375.0
}

// fit screen height  6Plus
func FIT_SCREEN_HEIGHT(_ size: CGFloat) -> CGFloat {
    return size * SCREEN_HEIGHT / 667.0
}

// fit screen text font
func AUTO_FONT(_ size: CGFloat) -> UIFont {
    let autoSize = size * SCREEN_WIDTH / 375.0
    return UIFont.systemFont(ofSize: autoSize)
}

func Localizaed(_ string : String?) -> String {
    return NSLocalizedString(string!, comment: string!)
}

let ScreenRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)

/** Color */
// RGBColor
func RGB_COLOR(_ r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}

func MAIN_COLOR() -> UIColor{
    return RGB_COLOR(21, g: 158, b: 221, alpha: 1)
}

func isValidDic(_ dic: NSDictionary?) -> Bool {
    if dic == nil || dic?.count == 0{
        return false
    }else{
        return true
    }
}

func isValidString(_ str:String?) -> Bool {
    if str == nil || str?.count == 0 || str == "" || str?.count == nil {
        return false
    }else{
        return true
    }
}

func isValidArray(_ array:NSArray?) -> Bool{
    if array == nil || array?.count == 0 || array?.count == nil{
        return false
    }else{
        return true
    }
}

func button_cannot_click(_ button: UIButton) {
    button.isEnabled = false
    button.alpha = 0.5
}

func button_can_click(_ button: UIButton) {
    button.isEnabled = true
    button.alpha = 1.0
}


