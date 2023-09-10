//
//  NSObject+getKeyNames.swift
//  Gululu
//
//  Created by Ray Xu on 18/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
extension NSObject {
    func keyNames() -> Array<String> {
        var results: Array<String> = []
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        let properties = class_copyPropertyList(myClass, &count)
        
        // iterate each objc_property_t struct
        for i in 0..<count {
            let property = properties?[Int(i)]
            let cname = property_getName(property!)
            let name = String(cString: cname);
            results.append(name);
        }
        free(properties);
        
        return results;
    }
    var className: String {
        return NSStringFromClass(type(of: self))
    }
    
    func getValue(_ key: String) -> NSObject? {
        if let mapping = (Mirror(reflecting: self).children.filter({$0.0 == key}).first) {
            if let value = mapping.value as? NSObject {
                return value
            }
        }
        return nil
    }
    
}





