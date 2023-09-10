//
//  NSManagedObjectContext+operations.swift
//  Gululu
//
//  Created by Ray Xu on 17/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import CoreData
import Foundation

public extension NSManagedObjectContext {

    public func delete<T: NSManagedObject>(objects: [T]) {
        guard objects.count != 0 else { return }
        
        self.performAndWait {
            for each in objects {
                self.delete(each)
            }
        }
    }
    

//    public func fetch<T: NSManagedObject>(request: FetchRequest<T>) throws -> [T] {
//        var results = [AnyObject]()
//        var caughtError: NSError?
//        
//        performAndWait {
//            do {
//                results = try self.fetch(request)
//            }
//            catch {
//                caughtError = error as NSError
//            }
//        }
//        
//        guard caughtError == nil else { throw caughtError! }
//        
//        return results as! [T]
//    }
 
}
