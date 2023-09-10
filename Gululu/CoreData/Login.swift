//
//  Login.swift
//  Gululu
//
//  Created by Ray Xu on 16/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

@objc(Login)
class Login: NSManagedObject{

    override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        
        if key == "propertyName" {
            // do something now when propertyName changed
        }
    }
}
