//
//  NSDictionary+Json.swift
//  Gululu
//
//  Created by Ray Xu on 20/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData
//TODO: Remove print
extension NSDictionary {
    func convertToModel<T: NSObject>(_ obj:T){
        var nameMapper=[String:String]()
        jsonMapper.forEach({nameMapper[$0.1]=$0.0})
        if (obj as? NSManagedObject)?.managedObjectContext == nil {
            backgroundMoc!.insert(obj as! NSManagedObject)
        }
        obj.keyNames().forEach{
            if let value = self[$0] {
                if value is NSNull {return}
                //no need to translate, same name as NSObject
                let oldVal=obj.getValue($0)
                if oldVal != value as? NSObject {
                    obj.setValue(value, forKey: $0)
                }
            }else {
                if let k2 = nameMapper[$0] {
                    if let value = self[k2] {
                        if value is NSNull {return}
                        let oldVal=obj.getValue(k2)
                        if oldVal != value as? NSObject {
                            obj.setValue(value, forKey: $0)
                        }
                    }
                }else{
                    //print("\($0) not found")
                }
            }
        }
        let cID = activeChildID
        if obj.keyNames().contains("childID") { //need a default childID
            if obj.value(forKey: "childID") == nil {
                obj.setValue(cID, forKey: "childID")
            }
        }
        if let val=self["x_user_token"] {
            cloudObj().token = val as? String
        }
    }
}
