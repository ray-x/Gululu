//
//  MockCloudCommon.swift
//  Gululu
//
//  Created by Baker on 17/1/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import CoreData

//class MockClass: NSObject{
//    static let mockObject = MockClass()
//    
//    override init() {
//        
//    }
//}

class MockCloudCommon: CloudComm {
    
    static let mockShareObject = MockCloudCommon()
    
    typealias ServiceResponseFR = ( ( Result<NSDictionary>) -> Void )
    
    var resultPost : NSDictionary = [:]
    
    override func httpHttpReq(_ req: APIDetail, token:String?=nil, header: [String: AnyObject]?=nil, body: [String: AnyObject]?=nil, netCallback: @escaping ServiceResponseFR){
        if resultPost.count != 0{
            netCallback(Result(success:resultPost))
        }
    }
}

class MockCoreData: NSObject {
    
    static let mockShareObject = MockCoreData()

    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
}

