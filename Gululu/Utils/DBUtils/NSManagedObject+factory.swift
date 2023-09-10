//
//  NSManagedObject+factory.swift
//  Gululu
//
//  Created by Ray Xu on 17/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func entityName() -> String {
        let name = NSStringFromClass(self)
        return name.components(separatedBy: ".").last!
    }

    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = type(of: self).entityName()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
    }
}

func fetchObject(_ classtype :AnyClass, context: NSManagedObjectContext, childID:String?=nil, key:AnyObject?=nil, predicator:String?=nil ) -> NSManagedObject? {
    let name = NSStringFromClass(classtype)
    let entityName = name.components(separatedBy: ".").last!
    let tableName=entityName.split(separator: "_").first.map(String.init)
    let keyName = entityKey[tableName!]
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest (entityName: tableName! )
    if childID != nil && childID!.count>=10 {
        if (entityName == "Friends") {
            fetchRequest.predicate=NSPredicate(format: "friendID = %@", childID!)
        }else {
            fetchRequest.predicate=NSPredicate(format: "childID = %@", childID!)
        }
    }else if predicator != nil {
        fetchRequest.predicate=NSPredicate(format: predicator!)
    }
    if key != nil && (key?.stringValue != "" || key?.intValue != 0) {
        if let keyNum = key! as? Int {
            fetchRequest.predicate=NSPredicate(format: "%K = %d", keyName!,  keyNum)
        }else if let keyStr = key! as? String {
            fetchRequest.predicate=NSPredicate(format: "%K = %@",keyName!,  keyStr)
        }
    }
    
    do {
        let data=try context.fetch(fetchRequest)
        if data.count>0{
            return data[0] as? NSManagedObject
        }else{
            return nil
        }
    }catch{
        assertionFailure("update fetch error")
        return nil
    }
}
var err:NSError{
	return NSError(domain: "save context error", code: 0, userInfo: nil)
}

func fetchObjects(_ classtype:AnyClass, context: NSManagedObjectContext, ID:String? = nil, predicator:String?=nil ) -> [NSManagedObject]? {
    let name = NSStringFromClass(classtype)
    let entityName = name.components(separatedBy: ".").last!
    let tableName=entityName.split(separator: "_").first.map(String.init)
    let fetchRequest :NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tableName!)
    if ID != nil {
        fetchRequest.predicate=NSPredicate(format: "childID = % @", ID!)
    }else if predicator != nil {
        fetchRequest.predicate=NSPredicate(format: predicator!)
    }
    
    do {
        let data = try context.fetch(fetchRequest)
        if data.count>0{
            return data as? [NSManagedObject]
        }else {
            return nil
        }
    }catch{
        assertionFailure("update fetch error")
        return nil
    }
}


public func saveContext(_ wait: Bool = true, completion: ((Result<NSDictionary>) -> Void)? = nil) {
//    let appDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
//    let context = (backgroundMoc==nil)? appDelegate.managedObjectContext:
	guard let context = backgroundMoc else {completion?(.Error(err as NSError)); return}
    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    let block = {
        guard context.hasChanges else { return }
        do {
            try context.save()
            completion?(.Success(["result":"OK"]))
        }
        catch {
            let err = NSError(domain: "save context", code: 0, userInfo: nil)
            completion?(.Error(err as NSError))
        }
    }
    //Fix me wait forever
    wait ? context.performAndWait(block) : context.perform(block)
//    dispatch_async(dispatch_get_main_queue(), {
//    	
//	})
}


public func entity(name: String, context: NSManagedObjectContext) -> NSEntityDescription {
    return NSEntityDescription.entity(forEntityName: name, in: context)!
}

//open class FetchRequest<T: NSManagedObject>: NSFetchRequest <NSObject> {
//    public init(entity: NSEntityDescription) {
//        super()
//        self.entity = entity
//    }
//}

