//
//  UserInfo+CoreDataProperties.swift
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

extension UserInfo {

    @NSManaged var childID: String?
    @NSManaged var cupID: String?
    @NSManaged var email: String?
    @NSManaged var finishedRegister: NSNumber?
    @NSManaged var parentID: String?
    @NSManaged var petID: String?
    @NSManaged var timeZone: NSNumber?
    @NSManaged var userID: NSNumber?
    @NSManaged var userSn: String?
    @NSManaged var children: Children?
    @NSManaged var cup: Cups?
    @NSManaged var parent: Parents?

}
