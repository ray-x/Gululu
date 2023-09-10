//
//  GUButton.swift
//  Gululu
//
//  Created by Baker on 16/8/19.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

extension UIButton {
     func antiMultiplyTouch(_ delay : TimeInterval, closure:@escaping ()->()) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.isUserInteractionEnabled = true
                closure()
        })
    }
    
    func setleftImage(_ interval : CGFloat) {
        self.titleLabel!.backgroundColor = .clear
        self.imageView!.backgroundColor = .clear
        let  titleSize =  self.titleLabel!.bounds.size
        let imageSize =  self.imageView!.bounds.size
        let  interval : CGFloat = interval
        self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval))
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)
    }
    
    func setleftImageJustNew(_ interval : CGFloat) {
        self.titleLabel!.backgroundColor = .clear
        self.imageView!.backgroundColor = .clear
        let  titleSize =  self.titleLabel!.bounds.size
        let imageSize =  self.imageView!.bounds.size
        let  interval : CGFloat = interval
        self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + interval, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, 0)
    }
    
    func setleftImageJustNew2(_ interval : CGFloat) {
        self.titleLabel!.backgroundColor = .clear
        self.imageView!.backgroundColor = .clear
        let  titleSize =  self.titleLabel!.bounds.size
        let imageSize =  self.imageView!.bounds.size
        let  interval : CGFloat = interval
        self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval + 10, 0, -(titleSize.width + interval))
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval - 10), 0, imageSize.width + interval)
    }
    
    func setMiddleImageAndTitle(_ interval : CGFloat) {
        self.titleLabel!.backgroundColor = .clear
        self.imageView!.backgroundColor = .clear
        let  titleSize =  self.titleLabel!.bounds.size
        let imageSize =  self.imageView!.bounds.size
        let  interval : CGFloat = interval
        self.imageEdgeInsets = UIEdgeInsetsMake(0,(titleSize.width + interval)/2, 0, -(titleSize.width + interval)/2)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval)/2, 0, (imageSize.width + interval)/2)
    }
}

