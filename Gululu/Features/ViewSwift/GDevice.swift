//
//  GDevice.swift
//  Gululu
//
//  Created by baker on 2017/11/29.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GDevice: NSObject {

}

extension UIDevice {
    public func is_iPhoneX() -> Bool {
        if SCREEN_HEIGHT == 812 {
            return true
        }
        return false
    }
}
