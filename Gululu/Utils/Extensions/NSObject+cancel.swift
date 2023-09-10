//
//  NSObject+cancel.swift
//  Gululu
//
//  Created by Ray Xu on 31/07/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import CoreData
extension NSManagedObject {
    func cancel() {
        self.managedObjectContext?.refresh(self, mergeChanges: false)
    }
}
