//
//  GPetUnitTest.swift
//  Gululu
//
//  Created by Baker on 17/2/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
import CoreData

class GPetUnitTest: BaseTest {
    let test_model = GPet.share
    override func setUp() {
        super.setUp()
        GUser.share.activeChild = createObject(Children.self)
        
        activeChildID = "6GYAQVN712ZP"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShowNoPetModel() {
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]

        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.noPet)
        }
    }
    
    func test_Show3DActiveModel_first_init() {
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 22,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShow3DActiveModel() {
        
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE2"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 17242
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 22,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShow3DaddChangeModel() {
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE2"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 17242
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        
        GUser.share.activeChild?.childID = "6GYAQVN712ZP"
        GUser.share.activeChild?.hasCup = 1
        GUser.share.activeChild?.hasPet = 1
        
        saveContext()

        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 2200,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShow3DaddChangeModelWithOutPiared() {
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE2"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 17242
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        
        GUser.share.activeChild?.childID = "6GYAQVN712ZP"
        GUser.share.activeChild?.hasCup = 0
        GUser.share.activeChild?.hasPet = 1
        
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 2200,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShowpet2dActiveModel() {
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 17242
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 22,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShowpet2DchangeModel() {
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petID = "7W4KYU6JTZCR"
        petdddd.petNum = 17242
        backgroundMoc?.insert(petdddd)
        
        GUser.share.activeChild?.childID = "6GYAQVN712ZP"
        GUser.share.activeChild?.hasCup = 1
        GUser.share.activeChild?.hasPet = 1
        
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 3500,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
    }
    
    func testShowSyncModel() {
       
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE2"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 17242
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        
        GUser.share.activeChild?.childID = "6GYAQVN712ZP"
        GUser.share.activeChild?.hasCup = 1
        GUser.share.activeChild?.hasPet = 1
        
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 2200,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        let pet2 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 1,
                     "pet_current_level" : 1,
                     "pet_id" : 17233,
                     "pet_model" : "SANSA2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "NEXT",
                     "x_pet_sn" : "7W4KYU6JTZCF"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1,pet2], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.sync)
        }
        
    }
    
    func testShowSyncModelWithOutPaired() {
        
        let petdddd : Pets  = createObject(Pets.self)!
        petdddd.petName = "PURPIE2"
        petdddd.petStatus = "ACTIVE"
        petdddd.childID = activeChildID
        petdddd.petDepth = 1
        petdddd.petNum = 1111
        petdddd.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(petdddd)
        
        GUser.share.activeChild?.childID = "6GYAQVN712ZP"
        GUser.share.activeChild?.hasCup = 0
        GUser.share.activeChild?.hasPet = 1
        
        saveContext()
        
        let pet1 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 2200,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        let pet2 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 1,
                     "pet_current_level" : 1,
                     "pet_id" : 17233,
                     "pet_model" : "SANSA2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "NEXT",
                     "x_pet_sn" : "7W4KYU6JTZCF"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet1,pet2], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.active)
        }
        
    }
    
    func testShowFinsihModel() {
        
        let pet1 : Pets  = createObject(Pets.self)!
        pet1.petName = "PURPIE"
        pet1.petStatus = "ACTIVE"
        pet1.petDepth = 3500
        pet1.childID = activeChildID
        pet1.petID = "7W4KYU6JTZCR"
        pet1.petNum = 17242
        let pet2 : Pets  = createObject(Pets.self)!
        pet2.petName = "SANSA2"
        pet2.petStatus = "NEXT"
        pet2.petDepth = 10
        pet2.childID = activeChildID
        pet2.petID = "7W4KYU6JTZCF"
        pet2.petNum = 17233
        backgroundMoc?.insert(pet1)
        backgroundMoc?.insert(pet2)
        saveContext()
        
        let pet3 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 2200,
                     "pet_current_level" : 1,
                     "pet_id" : 17242,
                     "pet_model" : "PURPIE",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "FINISH",
                     "x_pet_sn" : "7W4KYU6JTZCR"] as [String : Any]
        let pet4 = [ "pet_created_date" : "2016-12-26 08:08:13",
                     "pet_current_depth" : 1,
                     "pet_current_level" : 1,
                     "pet_id" : 17233,
                     "pet_model" : "SANSA2",
                     "pet_modified_date" : "2017-02-28 03:51:02",
                     "pet_status" : "ACTIVE",
                     "x_pet_sn" : "7W4KYU6JTZCF"] as [String : Any]
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : [pet3,pet4], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        GPet.share.displayCurrentPet {
            XCTAssertEqual(GPet.share.showPetStatus, ShowPetStatus.byeBye)
        }
    }
    
    func testGetPetNames() {
        
        MockCloudCommon.mockShareObject.resultPost = [ "pets" : ["SANSA2", "NIJNI2", "PURPIE2", "DONNY2"], "status" : 1,"x_child_sn" : "6GYAQVN712ZP"]
        
//        GPet.share.getNextPetsFromRemote()
    }
    
    func testGetPetNamesFailed() {
        
        MockCloudCommon.mockShareObject.resultPost = [ "msg" : "", "status" : "Error", "status_code" : 404]
        
//        GPet.share.getNextPetsFromRemote()
    }
    
    func test_GetPetImageName() -> Void {
        XCTAssertEqual(GPet.share.getPetImageName("NINJI1"), "Ninji")
        XCTAssertEqual(GPet.share.getPetImageName("NINJI2"), "Ninji")
        XCTAssertEqual(GPet.share.getPetImageName("NINJI?"), "Ninji")
        
        XCTAssertEqual(GPet.share.getPetImageName("SANSA2"), "Sansa")
        XCTAssertEqual(GPet.share.getPetImageName("SANSA23"), "Sansa")
        XCTAssertEqual(GPet.share.getPetImageName("SANSA?"), "Sansa")

        XCTAssertEqual(GPet.share.getPetImageName("PURPIE1"), "Purpie")
        XCTAssertEqual(GPet.share.getPetImageName("PURPIE32"), "Purpie")
        XCTAssertEqual(GPet.share.getPetImageName("PURPIE?"), "Purpie")
        
        XCTAssertEqual(GPet.share.getPetImageName("DONNY1"), "Donny")
        XCTAssertEqual(GPet.share.getPetImageName("DONNY3"), "Donny")
        XCTAssertEqual(GPet.share.getPetImageName("DONNY??"), "Donny")

    }
    
    func test_ChangePetName() {
     
        XCTAssertEqual(GPet.share.changePetName(petName:""),Localizaed("Ninji"))
        XCTAssertEqual(GPet.share.changePetName(petName:"NINJI"),Localizaed("Ninji"))
        XCTAssertEqual(GPet.share.changePetName(petName:"ninji"),Localizaed("Ninji"))
        XCTAssertEqual(GPet.share.changePetName(petName:"NINJI2"),Localizaed("Ninji"))
        
        XCTAssertEqual(GPet.share.changePetName(petName:"SANSA"),Localizaed("Sansa"))
        XCTAssertEqual(GPet.share.changePetName(petName:"Sansa"),Localizaed("Sansa"))
        XCTAssertEqual(GPet.share.changePetName(petName:"sansa"),Localizaed("Sansa"))
        XCTAssertEqual(GPet.share.changePetName(petName:"SAnsa"),Localizaed("Sansa"))
        XCTAssertEqual(GPet.share.changePetName(petName:"SANSA2"),Localizaed("Sansa"))
        
        XCTAssertEqual(GPet.share.changePetName(petName:"PURPIE"),Localizaed("Purpie"))
        XCTAssertEqual(GPet.share.changePetName(petName:"purpie"),Localizaed("Purpie"))
        XCTAssertEqual(GPet.share.changePetName(petName:"PuRpie"),Localizaed("Purpie"))
        XCTAssertEqual(GPet.share.changePetName(petName:"PURPIE2"),Localizaed("Purpie"))
        
        XCTAssertEqual(GPet.share.changePetName(petName:"DONNY"),Localizaed("Donny"))
        XCTAssertEqual(GPet.share.changePetName(petName:"donny"),Localizaed("Donny"))
        XCTAssertEqual(GPet.share.changePetName(petName:"DonNy"),Localizaed("Donny"))
        XCTAssertEqual(GPet.share.changePetName(petName:"DONNY@"),Localizaed("Donny"))
        
    }
    
    func test_GetFinishPetsName() {
        let pet1: Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "ACTIVE"
        pet1.childID = activeChildID
        pet1.petDepth = 2000
        pet1.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(pet1)
        
        let pet2: Pets  = createObject(Pets.self)!
        pet2.petName = "SANSA2"
        pet2.petStatus = "FINISH"
        pet2.childID = activeChildID
        pet2.petDepth = 2000
        pet2.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(pet2)

        let pet3: Pets  = createObject(Pets.self)!
        pet3.petName = "SANSA"
        pet3.petStatus = "FINISH"
        pet3.childID = activeChildID
        pet3.petDepth = 2000
        pet3.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(pet3)

        let pet4: Pets  = createObject(Pets.self)!
        pet4.petName = "PURPIE2"
        pet4.petStatus = "FINISH"
        pet4.childID = activeChildID
        pet4.petDepth = 2000
        pet4.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(pet4)

        let pet6: Pets  = createObject(Pets.self)!
        pet6.petName = "PURPIE"
        pet6.petStatus = "FINISH"
        pet6.childID = activeChildID
        pet6.petDepth = 2000
        pet6.petID = "7W4KYU6JTZCR"
        backgroundMoc?.insert(pet6)

        saveContext()
        
        let finishPets : [String] = GPet.share.getfinsihandActivePetsName()
        XCTAssertEqual(finishPets.count, 3)
    }
    
    func test_GetActivePetName() {
        let pet1 : Pets  = createObject(Pets.self)!
        pet1.petName = "PURPIE"
        pet1.petStatus = "ACTIVE"
        pet1.petDepth = 3500
        pet1.childID = activeChildID
        pet1.petID = "7W4KYU6JTZCR"
        pet1.petNum = 17242

        backgroundMoc?.insert(pet1)
        saveContext()
        
        let petName = GPet.share.getActivePetName()
        XCTAssertEqual(petName, "Purpie")
    }
    
    func testGetActivePetName1() {
        let pet2 : Pets  = createObject(Pets.self)!
        pet2.petName = "SANSA2"
        pet2.petStatus = "ACTIVE"
        pet2.petDepth = 10
        pet2.childID = activeChildID
        pet2.petID = "7W4KYU6JTZCF"
        pet2.petNum = 17233
        backgroundMoc?.insert(pet2)
        saveContext()
        
        let petName = GPet.share.getActivePetName()
        XCTAssertEqual(petName, "Sansa")
    }
    
    func testGetActivePetName2() {
        let petName = GPet.share.getActivePetName()
        XCTAssertEqual(petName, "Ninji")
    }
    
    func testGetActivePetName3() {
        let pet2 : Pets  = createObject(Pets.self)!
        pet2.petName = "NINJI2"
        pet2.petStatus = "ACTIVE"
        pet2.petDepth = 10
        pet2.childID = activeChildID
        pet2.petID = "7W4KYU6JTZCF"
        pet2.petNum = 17233
        backgroundMoc?.insert(pet2)
        saveContext()
        
        let petName = GPet.share.getActivePetName()
        XCTAssertEqual(petName, "Ninji")
    }
    
    func test_getFinishAndActivePet() {
        let pet2 : Pets  = createObject(Pets.self)!
        pet2.petName = "SANSA2"
        pet2.petStatus = "ACTIVE"
        pet2.petDepth = 10
        pet2.petLevel = 200
        pet2.childID = activeChildID
        pet2.petID = "7W4KYU6JTZCF"
        pet2.petNum = 17233
        backgroundMoc?.insert(pet2)
        let pet1 : Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "FINISH"
        pet1.petDepth = 10
        pet1.petLevel = 100
        pet1.childID = activeChildID
        pet1.petID = "7W4KYU6JTZCF"
        pet1.petNum = 17233
        backgroundMoc?.insert(pet1)
        let pet3 : Pets  = createObject(Pets.self)!
        pet3.petName = "PURPIE2"
        pet3.petStatus = "NEXT"
        pet3.petDepth = 10
        pet3.petLevel = 300
        pet3.childID = activeChildID
        pet3.petID = "7W4KYU6JTZCF"
        pet3.petNum = 17233
        backgroundMoc?.insert(pet3)
        saveContext()

        GPet.share.readPetFromeLocal()
        
        XCTAssertEqual(GPet.share.petList.first?.petName, "NINJI2")
        XCTAssertEqual(GPet.share.petList.last?.petName, "PURPIE2")

    }
    
    func test_getNoRepeatPets() {

        let pet5 : Pets  = createObject(Pets.self)!
        pet5.petName = "PURPIE2"
        pet5.petStatus = "FINISH"
        pet5.petDepth = 10
        pet5.petLevel = 200
        pet5.childID = activeChildID
        pet5.petID = "7W4KYU6JTZCF"
        pet5.petNum = 17233
        backgroundMoc?.insert(pet5)
        let pet4 : Pets  = createObject(Pets.self)!
        pet4.petName = "SANSA2"
        pet4.petStatus = "FINISH"
        pet4.petDepth = 10
        pet4.petLevel = 200
        pet4.childID = activeChildID
        pet4.petID = "7W4KYU6JTZCF"
        pet4.petNum = 17233
        backgroundMoc?.insert(pet4)
        let pet2 : Pets  = createObject(Pets.self)!
        pet2.petName = "NINJI2"
        pet2.petStatus = "ACTIVE"
        pet2.petDepth = 10
        pet2.petLevel = 200
        pet2.childID = activeChildID
        pet2.petID = "7W4KYU6JTZCF"
        pet2.petNum = 17233
        backgroundMoc?.insert(pet2)
        let pet1 : Pets  = createObject(Pets.self)!
        pet1.petName = "NINJI2"
        pet1.petStatus = "FINISH"
        pet1.petDepth = 10
        pet1.petLevel = 100
        pet1.childID = activeChildID
        pet1.petID = "7W4KYU6JTZCF"
        pet1.petNum = 17233
        backgroundMoc?.insert(pet1)
        let pet3 : Pets  = createObject(Pets.self)!
        pet3.petName = "PURPIE2"
        pet3.petStatus = "NEXT"
        pet3.petDepth = 10
        pet3.petLevel = 300
        pet3.childID = activeChildID
        pet3.petID = "7W4KYU6JTZCF"
        pet3.petNum = 17233
        backgroundMoc?.insert(pet3)
        saveContext()
        
        GPet.share.readPetFromeLocal()

        let result = GPet.share.getNoRepeatPets()
        XCTAssertEqual(result.count, 3)
    }
    
    func test_getNoRepeatPets_1() {
        let pet6 : Pets  = createObject(Pets.self)!
        pet6.petName = "PURPIE2"
        pet6.petStatus = "FINISH"
        pet6.petDepth = 10
        pet6.petLevel = 200
        pet6.childID = activeChildID
        pet6.petID = "7W4KYU6JT"
        pet6.petNum = 17233
        backgroundMoc?.insert(pet6)
        let pet5 : Pets  = createObject(Pets.self)!
        pet5.petName = "PURPIE2"
        pet5.petStatus = "ACTIVE"
        pet5.petDepth = 10
        pet5.petLevel = 200
        pet5.childID = activeChildID
        pet5.petID = "7W4KYU6JCF"
        pet5.petNum = 17231
        backgroundMoc?.insert(pet5)
        let pet4 : Pets  = createObject(Pets.self)!
        pet4.petName = "PURPIE"
        pet4.petStatus = "FINSIH"
        pet4.petDepth = 10
        pet4.petLevel = 200
        pet4.childID = activeChildID
        pet4.petID = "7W4KYJTZCF"
        pet4.petNum = 172
        backgroundMoc?.insert(pet4)
       
        
        GPet.share.readPetFromeLocal()
        
        let result = GPet.share.getNoRepeatPets()
        XCTAssertEqual(result.count, 1)
    }
    
    func test_getNoRepeatPets_2() {
        let pet6 : Pets  = createObject(Pets.self)!
        pet6.petName = "PURPIE2"
        pet6.petStatus = "FINSIH"
        pet6.petDepth = 10
        pet6.petLevel = 200
        pet6.childID = activeChildID
        pet6.petID = "7W4KYU6JT"
        pet6.petNum = 17233
        backgroundMoc?.insert(pet6)
        let pet5 : Pets  = createObject(Pets.self)!
        pet5.petName = "PURPIE2"
        pet5.petStatus = "ACTIVE"
        pet5.petDepth = 10
        pet5.petLevel = 200
        pet5.childID = activeChildID
        pet5.petID = "7W4KYU6JCF"
        pet5.petNum = 17231
        backgroundMoc?.insert(pet5)
        let pet4 : Pets  = createObject(Pets.self)!
        pet4.petName = "PURPIE"
        pet4.petStatus = "FINSIH"
        pet4.petDepth = 10
        pet4.petLevel = 200
        pet4.childID = activeChildID
        pet4.petID = "7W4KYJTZCD"
        pet4.petNum = 172
        backgroundMoc?.insert(pet4)
        
        
        GPet.share.readPetFromeLocal()
        
        let result = GPet.share.getNoRepeatPets()
        XCTAssertEqual(result.count, 1)
    }
    
    func test_getNoRepeatPets_3() {
        let pet6 : Pets  = createObject(Pets.self)!
        pet6.petName = "SANSA2"
        pet6.petStatus = "FINISH"
        pet6.petDepth = 10
        pet6.petLevel = 200
        pet6.childID = activeChildID
        pet6.petID = "7W4KYU6JT"
        pet6.petNum = 17233
        backgroundMoc?.insert(pet6)
        let pet5 : Pets  = createObject(Pets.self)!
        pet5.petName = "PURPIE2"
        pet5.petStatus = "ACTIVE"
        pet5.petDepth = 10
        pet5.petLevel = 200
        pet5.childID = activeChildID
        pet5.petID = "7W4KYU6JCF"
        pet5.petNum = 17231
        backgroundMoc?.insert(pet5)
        let pet4 : Pets  = createObject(Pets.self)!
        pet4.petName = "SANSA"
        pet4.petStatus = "FINISH"
        pet4.petDepth = 10
        pet4.petLevel = 200
        pet4.childID = activeChildID
        pet4.petID = "7W4KYJTZCD"
        pet4.petNum = 172
        backgroundMoc?.insert(pet4)
        
        GPet.share.readPetFromeLocal()
        
        let result = GPet.share.getNoRepeatPets()
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.petID, "7W4KYU6JT")
        XCTAssertEqual(result.last?.petID, "7W4KYU6JCF")

    }
    
    func test_isSamePetName() {
        XCTAssertTrue(test_model.isSamePetName("SANSA", petName2:"SANSA2"))
        XCTAssertFalse(test_model.isSamePetName("SANSA", petName2:"PURPIE"))

    }
}
