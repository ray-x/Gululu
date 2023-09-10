//
//  BASlider.swift
//  Gululu
//
//  Created by baker on 2018/4/17.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import Foundation
//带有刻度的自定义滑块
class BASlider: UISlider {
    
    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        for view:UIView in subviews {
            if view.isKind(of: UIImageView.self){
                view.clipsToBounds = true
                view.contentMode = .left
            }
        }
        return bounds
    }
}
