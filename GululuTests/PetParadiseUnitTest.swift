//
//  PetParadiseUnitTest.swift
//  Gululu
//
//  Created by Baker on 17/2/22.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class PetParadiseUnitTest: BaseTest {
    
    let model = GPetParadise.share

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetPetPlants() {
  
        let planet1 = ["url": "","name": "plant1"]
        let planet2 = ["url": "","name": "plant2"]
        let planet3 = ["url": "","name": "plant3"]
        let planet4 = ["url": "","name": "plant4"]
        
        let plants = [planet1,planet2,planet3,planet4]
        
        MockCloudCommon.mockShareObject.resultPost = ["status" : 1,"plants" : plants] as NSDictionary
        model.getPetPlants({ result in
            XCTAssertEqual(result.count, 0)
        })
    }
    
    func testplantNameToArrayIndex() {
        XCTAssertEqual(model.plantNameToArrayIndex("plant1"), 1)
        XCTAssertEqual(model.plantNameToArrayIndex("plant2"), 2)
        XCTAssertEqual(model.plantNameToArrayIndex("plant3"), 3)
        XCTAssertEqual(model.plantNameToArrayIndex("plant4"), 4)
        XCTAssertEqual(model.plantNameToArrayIndex("plant5"), 5)
        XCTAssertEqual(model.plantNameToArrayIndex("plant6"), 6)
        XCTAssertEqual(model.plantNameToArrayIndex("plant7"), 7)
        XCTAssertEqual(model.plantNameToArrayIndex("plant8"), 8)
        XCTAssertEqual(model.plantNameToArrayIndex("plant9"), 9)
        XCTAssertEqual(model.plantNameToArrayIndex("plant10"), 10)
        XCTAssertEqual(model.plantNameToArrayIndex("plant11"), 11)

    }
    
    func testaddImageToWitchLayer() {
        XCTAssertEqual(model.addImageToWitchLayer(1), 1)
        XCTAssertEqual(model.addImageToWitchLayer(2), 1)
        XCTAssertEqual(model.addImageToWitchLayer(3), 1)
        XCTAssertEqual(model.addImageToWitchLayer(4), 1)
        XCTAssertEqual(model.addImageToWitchLayer(5), 2)
        XCTAssertEqual(model.addImageToWitchLayer(6), 2)
        XCTAssertEqual(model.addImageToWitchLayer(7), 2)
        XCTAssertEqual(model.addImageToWitchLayer(8), 2)
        XCTAssertEqual(model.addImageToWitchLayer(9), 3)
        XCTAssertEqual(model.addImageToWitchLayer(10), 3)
        XCTAssertEqual(model.addImageToWitchLayer(11), 4)
        XCTAssertEqual(model.addImageToWitchLayer(12), 5)
    }
    
    func testgetLayelScrollRate() {
        for i in 0...6{
           let result = model.getLayelScrollRate(i)
           print(result)
        }
    }
    
    func test_getChoseNextPetAinmationName() {
        XCTAssertEqual("ninji_open_egg", model.getChoseNextPetAinmationName("NINJI"))
        XCTAssertEqual("ninji_open_egg", model.getChoseNextPetAinmationName("NINJI2"))
        XCTAssertEqual("ninji_open_egg", model.getChoseNextPetAinmationName("NINJI3"))
        XCTAssertEqual("ninji_open_egg", model.getChoseNextPetAinmationName("Ninji"))
        
        XCTAssertEqual("sansa_open_egg", model.getChoseNextPetAinmationName("SANSA"))
        XCTAssertEqual("sansa_open_egg", model.getChoseNextPetAinmationName("SANSA2"))
        XCTAssertEqual("sansa_open_egg", model.getChoseNextPetAinmationName("SANSA3"))
        XCTAssertEqual("sansa_open_egg", model.getChoseNextPetAinmationName("Sansa"))
        
        XCTAssertEqual("purpie_open_egg", model.getChoseNextPetAinmationName("PURPIE"))
        XCTAssertEqual("purpie_open_egg", model.getChoseNextPetAinmationName("PUrpie2"))
        XCTAssertEqual("purpie_open_egg", model.getChoseNextPetAinmationName("PURPIE3"))
        XCTAssertEqual("purpie_open_egg", model.getChoseNextPetAinmationName("Purpie"))
        
        XCTAssertEqual("donny_open_egg", model.getChoseNextPetAinmationName("DONNY"))
        XCTAssertEqual("donny_open_egg", model.getChoseNextPetAinmationName("DOnny2"))
        XCTAssertEqual("donny_open_egg", model.getChoseNextPetAinmationName("DONNY3"))
        XCTAssertEqual("donny_open_egg", model.getChoseNextPetAinmationName("Donny"))
    }
    
    func test_checkout_confirm_button_hidden()  {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "ACTIVE"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        
        GPet.share.showPetStatus = .sync
        XCTAssertFalse(model.checkout_confirm_button_hidden(pet1))
    }
    
    func test_checkout_confirm_button_hidden_0()  {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "NEXT"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        
        GPet.share.showPetStatus = .sync
        XCTAssertTrue(model.checkout_confirm_button_hidden(pet1))
    }
    
    func test_checkout_confirm_button_hidden_1()  {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "ACTIVE"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        
        GPet.share.showPetStatus = .active
        XCTAssertTrue(model.checkout_confirm_button_hidden(pet1))
    }
    
    func test_checkout_confirm_button_hidden_2()  {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "FINISH"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        
        GPet.share.showPetStatus = .active
        XCTAssertFalse(model.checkout_confirm_button_hidden(pet1))
    }
    
    func test_checkout_confirm_button_hidden_3()  {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "FINISH"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        
        GPet.share.showPetStatus = .sync
        XCTAssertFalse(model.checkout_confirm_button_hidden(pet1))
    }
    
    func test_checkout_add_egg() {
        GPet.share.can_add_pet = true
        XCTAssertTrue(model.checkout_add_egg(true))
    }
    
    func test_checkout_add_egg_1() {
//        GUserConfigUtil.share.feature_on.removeAllObjects()
        XCTAssertFalse(model.checkout_add_egg(false))
    }
    
    func test_checkout_add_egg_2() {
        GUserConfigUtil.share.feature_on.adding(GUserConfigUtil.share.ADD_NEXT_PET)
        GPet.share.can_add_pet = false
        GPet.share.pet_notify_level = 20
        XCTAssertTrue(model.checkout_add_egg(true))
    }
    
    func test_checkout_add_egg_3() {
        GUserConfigUtil.share.feature_on.adding(GUserConfigUtil.share.ADD_NEXT_PET)
        GPet.share.can_add_pet = false
        GPet.share.pet_notify_level = -1
        XCTAssertFalse(model.checkout_add_egg(true))
    }
    
    func test_check_can_request_pet_switch() {
        XCTAssertTrue(model.check_can_request_pet_switch(true))
    }
    
    func test_check_can_request_pet_switch_1() {
        XCTAssertFalse(model.check_can_request_pet_switch(false))
        XCTAssertEqual(-1, GPet.share.pet_notify_level.floatValue)
        XCTAssertTrue(GPet.share.can_add_pet)
    }
    
}
