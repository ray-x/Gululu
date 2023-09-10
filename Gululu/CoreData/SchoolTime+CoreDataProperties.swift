//
//  SchoolTime+CoreDataProperties.swift
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

extension SchoolTime {

    @NSManaged var childID: String?
    @NSManaged var createDate: NSNumber?
    @NSManaged var cupID: String?
    @NSManaged var morningFromHr: NSNumber?
    @NSManaged var morningFromMin: NSNumber?
    @NSManaged var morningID: NSNumber?
    @NSManaged var morningToHr: NSNumber?
    @NSManaged var morningToMin: NSNumber?
    @NSManaged var noonFromHr: NSNumber?
    @NSManaged var noonFromMin: NSNumber?
    @NSManaged var noonID: NSNumber?
    @NSManaged var noonToHr: NSNumber?
    @NSManaged var noonToMin: NSNumber?
    @NSManaged var schoolModeEn: NSNumber?
    @NSManaged var schoolMoningID: NSNumber?
    @NSManaged var schoolNoonID: NSNumber?
    @NSManaged var schoolRev3: String?
    @NSManaged var schoolRev4: String?
    @NSManaged var weekday: String?
    @NSManaged var child: Children?

}
