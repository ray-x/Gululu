//
//  SSID.swift
//  Gululu
//
//  Created by Ray Xu on 17/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

class SSID: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func checkIfSSIDTextValid(_ ssid: String) -> Bool
    {
        if ssid.count > 0
        {
            for i in 0...(ssid.count-1)
            {
                let iStr = (ssid as NSString).substring(with: NSRange(location: i, length: 1))
                if self.checkTextUniqueCharacter(iStr)
                {
                    return false
                }
            }
        }
        else
        {
            return false
        }
        return true
    }
    
    func checkTextUniqueCharacter(_ char: String) -> Bool
    {
        let index = char.unicodeScalars.first?.value
        if 32 <= index && index <= 126
        {
            return false
        }
        return true
    }

}
