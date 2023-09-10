//
//  UserDataUnitTest.swift
//  Gululu
//
//  Created by Baker on 16/8/3.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import XCTest
@testable import Gululu
class UserDataUnitTest: BaseTest {
    
    let test_helper = GUser.share
    
    override func setUp() {
        super.setUp()
        let child : Children = createObject(Children.self)!
        child.childName = "baker"
        child.childID  = "test"
        
        let child1 : Children = createObject(Children.self)!
        child1.childName = "baker1"
        child1.childID = "test1"
        child1.hasCup = 1
        
        test_helper.childList = [Children]()
        test_helper.childList.append(child)
        test_helper.childList.append(child1)
        
        test_helper.workingChild = createObject(Children.self)!
        test_helper.workingChild?.childName = "workingName"
        
        test_helper.activeChild = createObject(Children.self)!
        test_helper.activeChild?.childName = "activeName"
        activeChildID = "activeID"
        test_helper.activeChild?.recommendWater = 800 as NSNumber
        test_helper.activeChild?.unit = "kg"
        test_helper.email = "baker.cheng@qq.com"
        test_helper.password = "123456"
        
        test_helper.childList.append(test_helper.activeChild!)
        
        test_helper.userSn = "123"
        cloudObj().token = "123"
        saveContext()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetHelpshiftUserEmailAndChildNameAndID() {
        let login : Login = createObject(Login.self)!
        login.userid = 111
        saveContext()
        test_helper.setHelpshiftUserEmailAndChildNameAndID(login)
    }
    
    func testSetHelperShfitMetadata() {
        let login : Login = createObject(Login.self)!
        login.userid = 111
        saveContext()
        let _ = test_helper.setHelperShfitMetadata()
    }
    
    func testTokenIsVailed() -> Void {
        let token : String =  "9463055F-C4C3-4923-9145-C202C61FEF59"
        XCTAssertTrue(test_helper.isTokenValid(token), "token is unvalied")
    }
    
    func testIsExistInChildList() {
        let childName = "baker1"
        XCTAssertTrue(test_helper.isExistInChildList(childName))
        
        let childName1 = "baker100"
        XCTAssertFalse(test_helper.isExistInChildList(childName1))
    }
    
    func testKgTurnKg() {
        let value = GChild.share.kgTurnKg(nil)
        XCTAssertEqual(value, 0)
    }
    
    func testKgTurnLbs() {
        let value = GChild.share.kgTurnLbs(nil)
        XCTAssertEqual(Int(0), value)
    }
    
    func testWaterUnitMlTurnOz()  {
        let value = GChild.share.waterUnitMlTrunOz(800)
        XCTAssertEqual(value, Int(800*0.033814))
    }
    
    func testLoginWithLoginVC() {
        test_helper.showloginEntrance({ result in
            XCTAssertEqual(result, 0)
        })
    }
    
    func testLoginWithNoChild() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userSn = "74R3PNVU5JQ8"
        login.userid = 1234
        backgroundMoc?.insert(login)
        saveContext()
        
        test_helper.showloginEntrance({ result in
            XCTAssertEqual(result, 2)
        })
    }
    
    func testLoginWithMainVC() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        let child : Children = createObject(Children.self)!
        child.childID = "9350IGECS2XH"
        child.childName = "test"
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(child)
        saveContext()
        
        test_helper.showloginEntrance({ result in
            XCTAssertEqual(result, 1)
        })
    }
    
    func test_sting_to_int()  {
        let userID = String(format:"%@","17721149453")
        print(userID)
    }
    
    func test_getRealLogin() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
//        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        saveContext()
        
        XCTAssertNotNil(test_helper.getRealLogin())
    }
    
    func test_getRealLogin_0() {
        XCTAssertNil(test_helper.getRealLogin())
    }
    
    func test_getRealLogin_1() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        saveContext()
        XCTAssertNotNil(test_helper.getRealLogin(), "defalut str")
    }
    
    func test_getRealLogin_2() {
        let login1: Login = createObject(Login.self)!

        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        //        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(login1)

        saveContext()
        
        XCTAssertNotNil(test_helper.getRealLogin())
    }
    
    func test_getRealLogin_3() {
        let login1: Login = createObject(Login.self)!

        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(login1)
        
        saveContext()
        
        XCTAssertNotNil(test_helper.getRealLogin(), "defalut str")
    }
    
    func test_vaildate_login_1() {
        let login: Login = createObject(Login.self)!
        login.email = ""
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        XCTAssertFalse(test_helper.vaildate_login(login))
    }
    
    func test_vaildate_login_1_2() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = ""
        login.passwd = "dddd"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        XCTAssertFalse(test_helper.vaildate_login(login))
    }
    
    func test_vaildate_login_2() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = ""
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        XCTAssertFalse(test_helper.vaildate_login(login))
    }
    
    func test_vaildate_login_3() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 0
        login.userSn = "74R3PNVU5JQ8"
        
        XCTAssertFalse(test_helper.vaildate_login(login))
    }
    
    func test_vaildate_login_4() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 123
        login.userSn = ""
        
        XCTAssertFalse(test_helper.vaildate_login(login))
    }
    
    func test_vaildate_login_5() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        XCTAssertTrue(test_helper.vaildate_login(login))
    }
    
    func test_getRealLogin_5() {
        _ = test_helper.getRealLogin()
        let loginList : [Login]? = createObjects(Login.self) as? [Login]
        
        XCTAssertEqual(nil, loginList?.count)
    }
    
    func test_getRealLogin_6() {
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        saveContext()
        _ = test_helper.getRealLogin()
        let loginList : [Login]? = createObjects(Login.self) as? [Login]

        XCTAssertEqual(1, loginList?.count)
        
    }
    
    func test_getRealLogin_7() {
        let login1: Login = createObject(Login.self)!
        
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "123456"
        //        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(login1)
        saveContext()
        
        _ = test_helper.getRealLogin()
        let loginList : [Login]? = createObjects(Login.self) as? [Login]
        
        XCTAssertEqual(1, loginList?.count)
    }
    
    func test_getRealLogin_9() {
        let login1: Login = createObject(Login.self)!
        login1.email = "dddd"
        login1.passwd = "2222"
        
        let login: Login = createObject(Login.self)!
        login.email = "baker.cheng@qq.com"
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "dddd"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(login1)
        saveContext()
        
        _ = test_helper.getRealLogin()
        let loginList : [Login]? = createObjects(Login.self) as? [Login]
        
        XCTAssertEqual(2, loginList?.count)
    }
    
    func test_getRealLogin_10() {
        let login1: Login = createObject(Login.self)!
        
        let login: Login = createObject(Login.self)!
        login.email = ""
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "ddd"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        backgroundMoc?.insert(login)
        backgroundMoc?.insert(login1)
        saveContext()
        
        _ = test_helper.getRealLogin()
        let loginList : [Login]? = createObjects(Login.self) as? [Login]
        
        XCTAssertEqual(nil, loginList?.count)
    }
    
    func test_setHelpshiftUserEmailAndChildNameAndID()  {
        let login: Login = createObject(Login.self)!
        login.userid = nil
        test_helper.setHelpshiftUserEmailAndChildNameAndID(login)
    }
    
    func test_setHelpshiftUserEmailAndChildNameAndID_nil()  {
        test_helper.setHelpshiftUserEmailAndChildNameAndID(nil)
    }
    
    func test_setHelpshiftUserEmailAndChildNameAndID_1()  {
        let login: Login = createObject(Login.self)!
        login.email = ""
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "ddd"
        login.userid = 1345
        login.userSn = "74R3PNVU5JQ8"
        
        test_helper.setHelpshiftUserEmailAndChildNameAndID(login)
    }
    
    func test_setHelpshiftUserEmailAndChildNameAndID_2()  {
        let login: Login = createObject(Login.self)!
        login.email = ""
        login.token = "eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ5MDkzMzI4OSwiaWF0IjoxNDkwMzI4NDg5fQ.eyJjb25maXJtIjoyNjAyfQ.6KsjFXMwfvIkgUgu4t0wV6ytXNTb8LPjas8uxVIpvVc"
        login.passwd = "ddd"
        login.userid = 0
        login.userSn = "74R3PNVU5JQ8"
        
        test_helper.setHelpshiftUserEmailAndChildNameAndID(login)
        
    }
    
     
}
