//
//  Children+CoreDataProperties.swift
//  Gululu
//
//  Created by Ray Xu on 9/08/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Children {

    @NSManaged var avator: String?
    @NSManaged var birthday: String?
    @NSManaged var childID: String?
    @NSManaged var childName: String?
    @NSManaged var createdDate: String?
    @NSManaged var createTime: NSNumber?
    @NSManaged var cupID: String?
    @NSManaged var cupID2: String?
    @NSManaged var cupID3: String?
    @NSManaged var friendID: String?
    @NSManaged var gender: String?
    @NSManaged var habitIdx: NSNumber?
    @NSManaged var hasCup: NSNumber?
    @NSManaged var hasPet: NSNumber?
    @NSManaged var height: NSNumber?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var petID: String?
    @NSManaged var recommendWater: NSNumber?
    @NSManaged var unit: String?
    @NSManaged var weight: NSNumber?
    @NSManaged var weightLbs: NSNumber?
    @NSManaged var water_rate: NSNumber?
    @NSManaged var cup: Cups?
    @NSManaged var friend: Friends?
    @NSManaged var pet: Pets?

}
