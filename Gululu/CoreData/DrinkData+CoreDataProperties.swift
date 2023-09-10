//
//  DrinkData+CoreDataProperties.swift
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

extension DrinkData {

    @NSManaged var childID: String?
    @NSManaged var cupID: String?
    @NSManaged var time: Date?
    @NSManaged var vol: NSNumber?
    @NSManaged var child: Children?

}
