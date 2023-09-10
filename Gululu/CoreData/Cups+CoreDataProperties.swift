//
//  Cups+CoreDataProperties.swift
//  Gululu
//
//  Created by Ray Xu on 5/09/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cups {

    @NSManaged var childID: String?
    @NSManaged var cupBoughtDate: String?
    @NSManaged var cupColor: String?
    @NSManaged var cupID: String?
    @NSManaged var cupMac: String?
    @NSManaged var cupName: String?
    @NSManaged var cupSN: String?
    @NSManaged var model: String?
    @NSManaged var ssid: String?
    @NSManaged var child: Children?

}
