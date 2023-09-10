//
//  UpgradeTest.swift
//  Gululu
//
//  Created by Baker on 16/12/30.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class UpgradeTest: XCTestCase {
    var upgrade : MainUpgrade?
    override func setUp() {
        super.setUp()
        upgrade = MainUpgrade.shareInstance
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testExample() {
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testupdatePetGradeStatus(){
        
        var status = "upgrade_require"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.require)
        XCTAssertEqual(1, upgrade?.readPetStatusFromUserdefault())
        
        status = "no_upgrade_needed"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.downloading)
        XCTAssertEqual(2, upgrade?.readPetStatusFromUserdefault())
        
        status = "no_upgrade_needed"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.downloading)
        XCTAssertEqual(2, upgrade?.readPetStatusFromUserdefault())
        
        status = "ready_to_upgrade_pet2"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.ready)
        XCTAssertEqual(3, upgrade?.readPetStatusFromUserdefault())

        
        status = "upgrading"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.upgrading)
        XCTAssertEqual(4, upgrade?.readPetStatusFromUserdefault())
        
        status = "no_upgrade_needed"
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.done)
        XCTAssertEqual(5, upgrade?.readPetStatusFromUserdefault())
        
        status = ""
        upgrade?.updatePetGradeStatus(status)
        XCTAssertEqual(upgrade?.petGradeStatus, PetUpgradeStatus.noNeed)
        XCTAssertEqual(0, upgrade?.readPetStatusFromUserdefault())

    }
    
    func  testgetPetUpgradeStatusStr() {
        upgrade?.petGradeStatus = .upgrading
        XCTAssertEqual(Localizaed("JUST ONE\nSTEP AWAY!"),upgrade?.getPetUpgradeStatusStr())
        
        upgrade?.petGradeStatus = .ready
        XCTAssertEqual(Localizaed("READY TO\nUPGRADE!"),upgrade?.getPetUpgradeStatusStr())
        
        upgrade?.petGradeStatus = .downloading
        XCTAssertEqual(Localizaed("DOWN-\nLOADING..."),upgrade?.getPetUpgradeStatusStr())
        
        upgrade?.petGradeStatus = .require
        XCTAssertEqual(Localizaed("UPGRADE\nAVAILABLE!"),upgrade?.getPetUpgradeStatusStr())
        
        upgrade?.petGradeStatus = .done
        XCTAssertEqual(Localizaed("ALL DONE,\nSTART NEW ADVENTURE!"),upgrade?.getPetUpgradeStatusStr())
        
        upgrade?.petGradeStatus = .noNeed
        XCTAssertEqual(Localizaed("ALL DONE,\nSTART NEW ADVENTURE!"),upgrade?.getPetUpgradeStatusStr())
        
        
        
    }
    
    func testgetPetUpgradeImageStr() {
        upgrade?.petGradeStatus = .upgrading
        XCTAssertEqual("upgradeIcon",upgrade?.getPetUpgradeImageStr())
        
        upgrade?.petGradeStatus = .downloading
        XCTAssertEqual("upgradeIcon",upgrade?.getPetUpgradeImageStr())
        
        upgrade?.petGradeStatus = .ready
        XCTAssertEqual("upgradeIcon",upgrade?.getPetUpgradeImageStr())
        
        upgrade?.petGradeStatus = .require
        XCTAssertEqual("upgradeIcon",upgrade?.getPetUpgradeImageStr())
        
        upgrade?.petGradeStatus = .noNeed
        XCTAssertEqual("upgradeIcon",upgrade?.getPetUpgradeImageStr())
        
    }
    
    func testsetPetUpgradeData() {
        var data : [UpgradeInfoItem] = [UpgradeInfoItem]()
        upgrade?.petGradeStatus = .upgrading
        data = (upgrade?.setPetUpgradeData())!
        XCTAssertEqual(data.count, 1)
        
        upgrade?.petGradeStatus = .ready
        data = (upgrade?.setPetUpgradeData())!
        XCTAssertEqual(data.count, 4)
        
        upgrade?.petGradeStatus = .require
        data = (upgrade?.setPetUpgradeData())!
        XCTAssertEqual(data.count, 5)
        
        upgrade?.petGradeStatus = .done
        data = (upgrade?.setPetUpgradeData())!
        XCTAssertEqual(data.count, 3)
        
        upgrade?.petGradeStatus = .downloading
        data = (upgrade?.setPetUpgradeData())!
        XCTAssertEqual(data.count, 5)
    }
    
    func testgetUpgradeButtonTitle() {
        upgrade?.petGradeStatus = .require
        XCTAssertEqual(Localizaed("UPGRADE"), upgrade?.getUpgradeButtonTitle())
        
        upgrade?.petGradeStatus = .ready
        XCTAssertEqual(Localizaed("CHOOSE NEW PET"), upgrade?.getUpgradeButtonTitle())
        
        upgrade?.petGradeStatus = .upgrading
        XCTAssertEqual(Localizaed("GOT IT"), upgrade?.getUpgradeButtonTitle())
        
        upgrade?.petGradeStatus = .done
        XCTAssertEqual(DONE, upgrade?.getUpgradeButtonTitle())
        
        upgrade?.petGradeStatus = .noNeed
        XCTAssertEqual(DONE, upgrade?.getUpgradeButtonTitle())
        
        upgrade?.petGradeStatus = .downloading
        XCTAssertEqual(Localizaed("GOT IT"), upgrade?.getUpgradeButtonTitle())
    }
    
}
