//
//  testIsGululuAPSSID.swift
//  Gululu
//
//  Created by Wei on 2016/10/18.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class testIsGululuAPSSID: XCTestCase {
    var ssidVC: SSIDSetupVC!
    
    override func setUp() {
        super.setUp()
        let pairSB = UIStoryboard(name: "PairCup", bundle: nil)
        ssidVC = pairSB.instantiateViewControllerWithIdentifier("SSIDSetupVC") as! SSIDSetupVC
    }
    
    override func tearDown() {
        super.tearDown()
        ssidVC = nil
    }
    
    func testIsGululuAPTrue() {
        let ret1 = ssidVC.isGululuAPSSID("U1234", address: "192.168.21.1")
        XCTAssertTrue(ret1)
        
        let ret2 = ssidVC.isGululuAPSSID("U123A", address: "192.168.21.1")
        XCTAssertTrue(ret2)
        
        let ret3 = ssidVC.isGululuAPSSID("U12AB", address: "192.168.21.1")
        XCTAssertTrue(ret3)
        
        let ret4 = ssidVC.isGululuAPSSID("U1ABC", address: "192.168.21.1")
        XCTAssertTrue(ret4)
        
        let ret5 = ssidVC.isGululuAPSSID("UABCD", address: "192.168.21.1")
        XCTAssertTrue(ret5)
        
        let ret6 = ssidVC.isGululuAPSSID("UFFFF", address: "192.168.21.1")
        XCTAssertTrue(ret6)
    }
    
    func testIsGululuAPFalse() {
        let ret1 = ssidVC.isGululuAPSSID("U1234", address: "192.168.2.1")
        XCTAssertFalse(ret1)
        
        let ret2 = ssidVC.isGululuAPSSID("U1234", address: "192.1.21.1")
        XCTAssertFalse(ret2)
        
        let ret3 = ssidVC.isGululuAPSSID("U1234", address: "1.168.21.1")
        XCTAssertFalse(ret3)
        
        let ret4 = ssidVC.isGululuAPSSID("U1234", address: "1.1.1.1")
        XCTAssertFalse(ret4)
        
        let ret5 = ssidVC.isGululuAPSSID("1234U", address: "192.168.21.1")
        XCTAssertFalse(ret5)
        
        let ret6 = ssidVC.isGululuAPSSID("12U34", address: "192.168.21.1")
        XCTAssertFalse(ret6)
        
        let ret7 = ssidVC.isGululuAPSSID("1234U", address: "1.1.1.1")
        XCTAssertFalse(ret7)
    }
}
