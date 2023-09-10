//
//  dbUtils.swift
//  Gululu
//
//  Created by Ray Xu on 26/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData
//func deleteChildWithID(_ cid:String) -> Bool
//{
//    let managedContext = appDelegate.managedObjectContext
//    let uInfoFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Children")
//    uInfoFetchReq.predicate=NSPredicate(format: "childID = % @", cid)
//    do {
//        let childrenEty=(try managedContext.fetch(uInfoFetchReq)) as [Children?]
//
//        managedContext.delete(childrenEty[0]!)
//        try managedContext.save()
//
//    } catch {
//        assertionFailure("failed delete child")
//        return false
//    }
//    return true
//}

func removeObject(_ obj:NSManagedObject) {
    //for the object created with id/key only
    let managedContext = appDelegate.managedObjectContext
    managedContext.refresh(obj, mergeChanges: false)
}

func undoLastChange(_ obj:NSManagedObject) {
    if obj.managedObjectContext != nil {
        obj.managedObjectContext?.undo()
    }
}
