//
//  WakeSleep+CoreDataProperties.swift
//  Gululu
//
//  Created by Ray Xu on 28/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WakeSleep {

    @NSManaged var childID: String?
    @NSManaged var cupID: String?
    @NSManaged var sleepEn: NSNumber?
    @NSManaged var sleepHr: NSNumber?
    @NSManaged var sleepMin: NSNumber?
    @NSManaged var wakeHr: NSNumber?
    @NSManaged var wakeID: NSNumber?
    @NSManaged var wakeMin: NSNumber?
    @NSManaged var weekday: String?
    @NSManaged var child: Children?

}
