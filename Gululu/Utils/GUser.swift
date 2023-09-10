//
//  UserData.swift
//  Gululu
//
//  Created by Baker on 16/7/26.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

enum AppStatus: Int {
    case unregistered=0
    case registered
    case main
    case changeProfile
    case addChild
    case addPet
    case changeWifi
    case bindCup
    case changePet
    case deleteChild
    case upgradePet
}

class GUser: NSObject {

    static let share = GUser()
    
    let workingChildID : String = "workingID"
    var email : String?
    var password : String?
    var userSn : String?
    var verification_key : String = ""
    var workingChild : Children?
    var activeChild : Children?

    var appStatus: AppStatus = .unregistered
    var showBanner: Bool = false
    var childList : [Children]
    var photoPath : String?
    var workingChildChosePhoto : Bool = false
    var isChildCreated: Bool = false
    var addChildSucced = false
    
    func updateChildList() -> Void {
        childList.removeAll()
        let childListFromData:[Children]? = createObjects(Children.self) as? [Children]
        guard childListFromData != nil else {
            return
        }
        var middleChildList : [Children] = childListFromData!
        
        for i in 0...middleChildList.count-1 {
            let child = middleChildList[i]
            guard  child.childID != nil else {
                return
            }
            if !isExistInChildList(child.childName!){
                childList.append(child)
            }
        }
        
        sort("date")
        guard childList.count != 0 else {
            print("no child")
            return
        }
        guard readActiveChildID() != nil && readActiveChildID() != "" else {
            setGlobalChild(childList[0])
            return
        }
        let childInList = getActiveChildFromChildList()
        setGlobalChild(childInList)
        guard activeChild == nil else {
            return
        }
        setGlobalChild(childList[0])
    }
    
    func updateCurrentChildInChildList()  {
        for i in 0...childList.count-1 {
            let child = childList[i]
            guard  child.childID != nil else {
                return
            }
            if(activeChild?.childID == child.childID)
            {
                child.hasCup = activeChild?.hasCup
                break;
            }
        }
    }
    
    func getUserAccount() -> String {
        let login : Login? = getRealLogin()
        guard  login != nil else {
            return ""
        }
        return (login?.email)!
    }
    
    func getUserSn() -> String {
        let login : Login? = getRealLogin()
        guard  login != nil else {
            return ""
        }
        return (login?.userSn)!
    }
    
    func changeAvtiveChild(_ index: Int) {
        if index >= 0 && index <= childList.count{
            let child = (childList as NSArray).object(at: index) as? Children
            setGlobalChild(child!)
        }else{
            let child = (childList as NSArray).object(at: 0) as? Children
            setGlobalChild(child!)
        }
    }
    
    func setGlobalChild(_ child: Children?) {
        guard child != nil  else {
            return
        }
        activeChild = child
        setGlobalChildID()
        saveActiveChildID()
    }

    func setGlobalChildID() {
        guard activeChild?.childID != nil else {
//            updateChildList()
            return
        }
        activeChildID = (activeChild?.childID!)!
    }
    
    func getActiveChildFromChildList() -> Children?{
        let saveChildId = readActiveChildID()
        for child in childList {
            if child.childID == saveChildId {
                return child
            }
        }
        return nil
    }
    
    func saveActiveChildID() {
        UserDefaults.standard.set(activeChildID, forKey: ACTIVECHILDID)
    }
    
    func removeUserDefaultsID() {
        UserDefaults.standard.removeObject(forKey: ACTIVECHILDID)
    }
    
    func readActiveChildID() -> String?{
        let str : String? = UserDefaults.standard.object(forKey: ACTIVECHILDID) as? String
        return str
    }
    
    func sort(_ sortType : String) -> Void {
        switch sortType {
        case "name":
            childList.sort{
                $0.childName > $1.childName
            }
        case "date":
            childList.sort{
                $1.createdDate > $0.createdDate
            }
        default:
            break
        }
    }
    
    func userLogOut() {
        removeChildAvator()
        childList.removeAll()
        removeUserDefaultsID()
        email = nil
        userSn = nil
        cloudObj().token = nil
        workingChild = nil
        activeChild = nil
        HelpshiftCore.logout()
        logoutUser()
    }
    
    func removeChildAvator() {
        for child : Children in childList {
            AvatorHelper.share.removeChildAvator(child.childID!);
        }
    }
    
    func isTokenValid(_ token: String) -> Bool {
        if token.count < 10 || token.lengthOfBytes(using: String.Encoding.utf8) < 3 {
            return false
        }
        return true
    }
    
    func isExistInChildList(_ aChildName:String) -> Bool {
        if childList.count == 0{
            return false
        }
        for child : Children in childList {
            if child.childName == aChildName {
                return true
            }
        }
        return false
    }
    
    func isExistFriendInChildList(_ x_child_sn:String) -> Bool {
        if childList.count == 0{
            return false
        }
        for child : Children in childList {
            if child.childID == x_child_sn {
                return true
            }
        }
        return false
    }
    
    override init() {
        childList = [Children]()
        super.init()
    }
 
    func showloginEntrance(_ cloudCallback:@escaping (Int) -> Void) {
        let login : Login? = getRealLogin()
        guard login != nil else {
            cloudCallback(0)
            return
        }

        if GChild.share.isHaveChild(){
            self.updateChildList()
            self.appStatus = .main
            cloudCallback(1)
        }else{
            self.appStatus = .registered
            cloudCallback(2)
        }
    }
    
    func setHelpshiftUserEmailAndChildNameAndID(_ login: Login?) {
        guard login != nil else {
            return
        }
        guard login?.userid != nil else {
            return
        }
        guard activeChildID != "" else {
            return
        }
        let cupSN = GCup.share.readCupSnFromDB()
       
//        let userID = String(format:"%@",(login?.userid)!)
//        if Float(userID) <= 0{
//            return
//        }
        HelpshiftCore.login(withIdentifier: cupSN, withName:"", andEmail: login?.email)
    }
    
    func setHelperShfitMetadata() -> HelpshiftAPIConfig{
        let login : Login? = getRealLogin()
        setHelpshiftUserEmailAndChildNameAndID(login)
        
        var metaData = ["install_time":AppData.share.getAppInstallFirstTime()]
        
        if LoginHelper.share.checkUserInputIsEmail(self.email){
            metaData["email"] = self.email
        }else{
            metaData["phone"] = self.email
        }
        
        for i in 0...childList.count-1{
            let child = childList[i]
            let metaValue : String?
            if GChild.share.childIsHaveCupFromChild(child){
                metaValue = String(format:"Cup_sn: %@ | Game_version: %@ | Firmware_version: %@ | Network_version: %@ | Drink_num: %d",GCup.share.readCupSnFromChild(child),DeviceInfoHelper.share.getGameVerion(child),DeviceInfoHelper.share.getFirmwareVersion(child),DeviceInfoHelper.share.getNetworkVersion(child),GChild.share.readChildDrinkHourData(child))
            }else{
                metaValue = String(format:"Cup_sn: %@ | Drink_num: %d",GCup.share.readCupSnFromChild(child),GChild.share.readChildDrinkHourData(child))
            }
            metaData[child.childName!] = metaValue
        }
        let  builder = HelpshiftAPIConfigBuilder()
        builder.customMetaData = HelpshiftSupportMetaData(metaData: metaData)
        
        if Common.checkPreferredLanguagesIsEn(){
            builder.hideNameAndEmail = true
            builder.enableFullPrivacy = true
        }
    
        let apiConfig = builder.build()
        return apiConfig!
    }
    
    func getRealLogin() -> Login? {
        let loginList : [Login]? = createObjects(Login.self) as? [Login]
        guard loginList?.count != 0 && loginList != nil else {
            return nil
        }
        
        let true_login: Login? = get_right_login(loginList)
        if true_login != nil {
            GLoginUtil.share.setConfigServiceWithLogin(true_login)
            setHelpshiftUserEmailAndChildNameAndID(true_login)
            return true_login
        }else{
            let fake_login: Login? = get_fake_login(loginList)
            if fake_login != nil{
                BH_INFO_LOG("reload fake login")
                review_user_info(fake_login, cloudCallback: { (result) in
                        GLoginUtil.share.setConfigServiceWithLogin(fake_login)
                        self.setHelpshiftUserEmailAndChildNameAndID(fake_login)
                    })
                return fake_login
            }else{
                return nil
            }
        }
    }
    
    func get_right_login(_ loginlist: [Login]?) -> Login?  {
        guard loginlist?.count != 0 && loginlist != nil else {
            return nil
        }
        var true_login: Login?
        for login : Login in loginlist! {
            if vaildate_login(login){
                true_login = login
                break
            }
        }
        return true_login
    }
    
    func get_fake_login(_ loginlist: [Login]?) -> Login?  {
        guard loginlist?.count != 0 && loginlist != nil else {
            return nil
        }
        var true_login: Login?
        for login : Login in loginlist! {
            if validate_fack_login(login){
                true_login = login
                break
            }
        }
        return true_login
    }
    
    func validate_fack_login(_ login: Login?) -> Bool {
        if !isValidString(login?.email){
            BH_INFO_LOG("delete no valid login")
            backgroundMoc?.delete(login!)
            saveContext()
            return false
        }
        if !isValidString(login?.passwd){
            BH_INFO_LOG("delete no valid login")
            backgroundMoc?.delete(login!)
            saveContext()
            return false
        }
        return true
    }
    
    func vaildate_login(_ login: Login?) -> Bool {
        if !validate_fack_login(login){
            return false
        }
        if login?.userid == nil || login?.userid?.floatValue <= 0{
            BH_WARNING_LOG("user id warrning and review user info")
            return false
        }
        if !isValidString(login?.userSn){
            BH_WARNING_LOG("user usersn is not valid string")
            return false
        }
        if !isValidString(login?.token){
            BH_WARNING_LOG("user token is not valid string")
            return false
        }
        return true
    }
    
    func getIndexPathWithChildSN(_ childSN: String) -> Int {
        var index = -1
        let childrenArray: NSArray = childList as NSArray
        
        for child in childrenArray {
            let childInfo = child as! Children
            if childInfo.childID == childSN {
                index = childrenArray.index(of: child)
                break
            }
        }
        return index
    }
}
