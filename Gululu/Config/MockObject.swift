//
//  MockObject.swift
//  Gululu
//
//  Created by Baker on 17/1/18.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

extension NSObject{
    func cloudObj() -> CloudComm{
        return BaseObject.share.cloudObject
    }
}

class BaseObject: NSObject {
    static let share = BaseObject()

    var cloudObject : CloudComm = CloudComm.shareObject
}

