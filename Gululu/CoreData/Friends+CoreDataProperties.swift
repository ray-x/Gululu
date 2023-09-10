//
//  Friends+CoreDataProperties.swift
//  Gululu
//
//  Created by Ray Xu on 31/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Friends {

    @NSManaged var childID: String?
    @NSManaged var cupID: String?
    @NSManaged var friendAvatar: NSObject?
    @NSManaged var friendBirthday: String?
    @NSManaged var friendhabitIdx: NSNumber?
    @NSManaged var friendHabitUpdateTime: String?
    @NSManaged var friendID: String?
    @NSManaged var friendName: String?
    @NSManaged var friendPet: String?
    @NSManaged var friendPetDepth: NSNumber?
    @NSManaged var friendPetLevel: NSNumber?
    @NSManaged var friendPetUpdateTime: String?
    @NSManaged var friendPhotoUpdateTime: String?
    @NSManaged var friendPhotoURL: String?
    @NSManaged var friendPhotoURL2: String?
    @NSManaged var friendSocialNumber: NSNumber?
    @NSManaged var child: Children?

}
