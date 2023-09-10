//
//  LogoutUser.swift
//  Gululu
//
//  Created by Ray Xu on 29/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData

func removeDataFromTable(_ tableName:String)
{
    let context: NSManagedObjectContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
    if #available(iOS 9.0, *) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            //5
        } catch {
            print (error)
        }
    } else {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            try context.save()   
        } catch let error as NSError {
            print("Detele all data in \(tableName) error : \(error) \(error.userInfo)")
        }
    }
}


func logoutUser() {
    let _=["Login","Parents","Pets","SchoolTime","WakeSleep","UserInfo","Friends", "WakeSleep","Cups", "UserInfo","Children"].map({ removeDataFromTable($0) })
    
}
    
