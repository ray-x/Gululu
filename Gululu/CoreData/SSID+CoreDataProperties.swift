//
//  SSID+CoreDataProperties.swift
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

extension SSID {

    @NSManaged var passwd: String?
    @NSManaged var ssid: String?
    @NSManaged var ssidRev1: String?
    @NSManaged var wifiDescrip: String?

}
