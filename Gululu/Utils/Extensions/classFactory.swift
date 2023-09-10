//
//  classFactory.swift
//
//  Created by Ray Xu on 15/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

public protocol REST {
    func updateAndSave()
    func fetchAndSave()
}

func getClassName(_ name:NSString)->NSString!{
    var range = name.range(of: "<.*>", options: NSString.CompareOptions.regularExpression)
    if range.location != NSNotFound{
        range.location += 1
        range.length -= 2
        return getClassName(name.substring(with: range) as NSString)
    }
    else{
        return name
    }
}

private var _backgroundMOC:NSManagedObjectContext?=nil
var backgroundMoc :NSManagedObjectContext?{
    get{
        return _backgroundMOC
    }
    set{
        _backgroundMOC = newValue
    }
}

//create/get object from database
//classtype: valid coreData object name
// Children, System , Cups, Parents, Pets, SchoolTime, WakeSleep, Friends Children, Login
// if class ID is nil will try to create a new object. otherwise, will try get current object

func createObject<T>( _ classtype :AnyClass, objectID:String?=nil, key:AnyObject?=nil, preString:String?=nil) -> T?{
    // the reason to create background MOC is appDelegate MOC always execute on Main thread,
    // which will cause more truble when run UT test
    if backgroundMoc==nil {
        _backgroundMOC=NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        _backgroundMOC!.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
    }
    let context = (backgroundMoc == nil) ? appDelegate.managedObjectContext : backgroundMoc
    
    let objectModel=appDelegate.managedObjectModel
    let entities=objectModel.entitiesByName.map {return $0.0}
    
    let c1 = NSStringFromClass(classtype)
    let className:String
    if c1.range(of: "_") != nil {
		className=String(c1.split(separator: "_").first!)
    }else{
        className=c1
    }
    print("create object for \(className)")
    let classInfo = String(className.split(separator: ".").last!)
    var retObj:T?=nil
    if entities.contains(classInfo) {
        if objectID != nil || preString != nil || key != nil {
            retObj = fetchObject(classtype, context: context!, childID:objectID, key:key, predicator:preString) as? T
        }else {
            retObj = newTempCoreDataInstance(classInfo, context:context!) as? T
        }
        return retObj
    }else{
        guard let theClass = NSClassFromString(className) as? NSObject.Type
            else {
                    assertionFailure("create \(className) failed")
                    return nil
                }
        let obj = theClass.init()
        return obj as? T
    }
}

func newTempCoreDataInstance<T:NSManagedObject>(_ name: String,  context: NSManagedObjectContext) -> T {
    //let entity = [NSEntityDescription entityForName:@"MyEntity" inManagedObjectContext:myMOC]
    let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
    let item:T = NSManagedObject(entity: entity, insertInto: nil) as! T
    return item
}

func newCoreDataInstance<T>(_ name: String,  context: NSManagedObjectContext) -> T {
    let item:T = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! T
    return item
}

// create/fetch list of objects from database, return nil if not found
func createObjects( _ classtype :AnyClass, id:String? = nil, preString:String?=nil, contextPrivate:NSManagedObjectContext?=nil) -> [NSManagedObject]?{
    if backgroundMoc==nil {
        _backgroundMOC=NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        _backgroundMOC!.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
    }
//    let context = (backgroundMoc == nil) ? appDelegate.managedObjectContext : backgroundMoc
    
    let context = (contextPrivate != nil) ? contextPrivate : backgroundMoc
    let className = NSStringFromClass(classtype)
    let classInfo = String(className.split(separator: ".").last!)

    let objectModel=appDelegate.managedObjectModel
    let entities=objectModel.entitiesByName.map {return $0.0}
    if entities.contains(classInfo) {
        return fetchObjects(classtype, context: context!, ID:id )
    }else{
        return nil
    }
}


