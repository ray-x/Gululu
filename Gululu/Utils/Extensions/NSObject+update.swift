//
//  NSObject+update.swift
//  Gululu
//
//  Created by Ray Xu on 19/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData
let e=NSError(domain: "json2Object", code: 2, userInfo: nil)
let s=["result":"Success"]
let entityKey=["Children":"childID", "Cups":"cupID","Pets":"petNum", "SchoolTime":"childID", "WakeSleep":"childID", "Friends":"friendID", "Login":"email","drinking":""]
//let jsonMapper=["x_child_sn":"childID"]
let arrayJsonKey=["children":"x_child_sn","friends":"x_child_sn","pets":"pet_id", "files":"","drinking":"", "cups":"x_cup_id"]

extension NSObject {

    func convertDict2Model (_ dict:NSDictionary, callback:(Result<NSDictionary>)->Void) -> Void {
        let s=["result":"Success"]
        //convert Dict to object model
        let arrayDict=arrayJsonKey.keys
        let c1=String(self.className.split(separator: ".").last!)
        let cName=String(c1.split(separator: "_").first!)
        let json_name=cName.lowercased() //snake case name from json!!
        print("save \(cName)")
        if ( cName.range(of: "SchoolTime") != nil ) {
            convert2SchoolTime(dict)
            saveContext()
            callback( Result<NSDictionary>.Success(s as NSDictionary))
            return
        }
        if ( cName.range(of: "Sleep") != nil) {
            convert2SleepTime(dict)
            saveContext()
            callback( Result<NSDictionary>.Success(s as NSDictionary) )
            return
        }
        if ( cName.range(of: "Friends") != nil) {
            convert2Friends(dict)
            saveContext()
            callback( Result<NSDictionary>.Success(s as NSDictionary) )
            return
        }

        if ( cName.range(of:"Children") != nil) {
            GChild.share.syncChild(dict,handleObject: self)
        }
        
        if ( cName.range(of:"Cup") != nil) {
            GCup.share.syncCup(dict,handleObject: self)
        }
        
        if ( cName.range(of:"Pets") != nil) {
            GPet.share.syncPet(dict,handleObject: self)
        }
        
        if (self as? NSManagedObject)?.managedObjectContext == nil {
            backgroundMoc!.insert(self as! NSManagedObject)
        }
        
        //current only works for DB objects!!
        var b = false
        if arrayDict.contains(json_name) , let arrayNodes = (dict[json_name] as? Array<NSDictionary>) {
            arrayNodes.forEach({
                if let keyName=arrayJsonKey[json_name] {  //array
                    let keyVal = $0[keyName]
                    var newObj:NSManagedObject?
                    if b {
                        newObj=createObject(type(of: self), key:keyVal! as AnyObject?)
                        if newObj == nil {newObj=createObject(type(of: self))}
                        ($0 ).convertToModel(newObj!)
                    }else {
                        ($0 ).convertToModel(self)
                        b = true
                    }
                }else {
                    ($0 ).convertToModel(self)
                }
                saveContext()
            })
        }else {
            dict.convertToModel(self)
            saveContext()
        }
        //if
        callback( .Success(s as NSDictionary) )
    }
    
    func deleteModel (_ dict:NSDictionary, callback:(Result<NSDictionary>)->Void) -> Void {
        let s=["result":"Success"]
        //convert Dict to object model
        let c1=String(self.className.split(separator: ".").last!)
         _ = String(c1.split(separator: "_").first!)
        
        if (self as? NSManagedObject)?.managedObjectContext != nil {
            if self.isKind(of: Children.self){
                let child : Children = self as! Children
                GChild.share.deleteAllChildIfSame(childID: child.childID)
                callback( .Success(s as NSDictionary) )
            }else {
                backgroundMoc!.delete(self as! NSManagedObject)
                saveContext()
                callback( .Success(s as NSDictionary) )
            }
        }else{
            let err = NSError(domain: "delete context", code: 0, userInfo: nil)
            callback( .Error(err as NSError))
        }
    }

    func update(_ ops:Operation = .create, uiCallback:@escaping (Result<NSDictionary>) -> Void ) {
        cloudObj().operation = ops
        let updateSignal = Signal<(NSObject, Operation)>()
        updateSignal.bind(cloudObj().createRESTRequest)
            //.bind(cloudObj.createRESTRequest2)
        //.ensure(Thread.main)//use ensure main thread in UT will cause hang!
        .bind(convertDict2Model)
        .onError { (error) in
            uiCallback(.Error(error))
        }
        .onSuccess{
            uiCallback(.Success($0))
        }
        updateSignal.update((self, ops))
    }
    
    
    func remove(_ ops:Operation = .delete, uiCallback:@escaping (Result<NSDictionary>) -> Void ) {
        let updateSignal = Signal<(NSObject, Operation)>()
        updateSignal.bind(cloudObj().createRESTRequest)
            //.ensure(Thread.main)//use ensure main thread in UT will cause hang!
            .bind(deleteModel)
            .onError { (error) in
                uiCallback(.Error(error))
            }
            .onSuccess{
                uiCallback(.Success($0))
        }
        updateSignal.update((self, ops))
    }
    
    func saveData(_ result:@escaping (Result<NSDictionary>) -> Void) {
        if self is NSManagedObject {
            saveContext(completion:result)
        }else{
            //save photo?
            //save recommand water
        }
    }
}
        
