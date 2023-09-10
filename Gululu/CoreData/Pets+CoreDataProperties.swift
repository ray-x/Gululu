//
//  Pets+CoreDataProperties.swift
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

extension Pets {

    @NSManaged var childID: String?
    @NSManaged var petAnimation: NSObject?
    @NSManaged var petAvatar: NSObject?
    @NSManaged var petDepth: NSNumber?
    @NSManaged var petDescription: String?
    @NSManaged var petID: String?
    @NSManaged var petLevel: NSNumber?
    @NSManaged var petName: String?
    @NSManaged var petNum: NSNumber?
    @NSManaged var petStatus: String?
    @NSManaged var petTime: Date?
    @NSManaged var cupID: String?
    @NSManaged var child: Children?

}
