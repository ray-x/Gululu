//
//  ILockView.swift
//  Gululu
//
//  Created by baker on 2018/6/26.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

protocol ILockView {
    
    typealias handleBlock = ()->()
    
    func showLock()
    
    func locked_done(block:handleBlock?) -> Void
}
