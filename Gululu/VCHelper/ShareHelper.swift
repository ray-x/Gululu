//
//  ShareHelper.swift
//  Gululu
//
//  Created by Baker on 17/7/13.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class ShareHelper: NSObject {

    static let share = ShareHelper()
    
    var click_platformType: UMSocialPlatformType = UMSocialPlatformType.unKnown
    
    var shareImage : UIImage?
    
    var shareUrl : URL?
    
    var result : Bool = false
    
    func getShareUrl(_ body : String) -> URL {
        return URL(string: body)!
    }
}
