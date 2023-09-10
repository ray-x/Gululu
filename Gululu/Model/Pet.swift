//
//  Pet.swift
//  Gululu
//
//  Created by Baker on 17/3/7.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class Pet: NSObject {
    
    static func savePet(_ pet:Pets){
        let dic = NSDictionary()
        pet.convertDict2Model(dic, callback: {_ in})
    }
    
    static func savePet_frome_dic(_ dic:NSDictionary){
        let pet : Pets = createObject(Pets.self)!
        pet.convertDict2Model(dic, callback:{_ in})
    }
    
}
