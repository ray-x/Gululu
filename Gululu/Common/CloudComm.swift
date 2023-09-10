
//
//  CloudComm.swift
//  Gululu
//
//  Created by Ray Xu on 31/10/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import Foundation
import UIKit

enum HttpType:String {
    case get="GET"
    case put="PUT"
    case post="POST"
    case delete = "DELETE"
}

enum Operation :String {
    case fetch="Fetch"
    case fetchAll="FetchAll"
    case update="Update"
    case create="Create"
    case createNext="CreateNext"
    case delete="Delete"
    case upgrade = "Upgrade"
}

struct APIDetail {
    let name:String
    let coredataName:String
    let http:HttpType
    var fields:[String]?
    var root:String?
    init(apiName:String, cdName:String, httpType:HttpType, JSONField:[String]?=nil,root:String?=nil ){
        name = apiName
        coredataName = cdName
        http = httpType
        fields = JSONField
        self.root = root
    }
}

var cloudAPI:[String:APIDetail]=[
    "LoginCreate":APIDetail(apiName: "user", cdName: "Login", httpType: .post, JSONField: ["email", "password", "mobile","name"])  , //register
    "LoginFetch": APIDetail(apiName: "login", cdName: "Login", httpType: .post, JSONField: ["email", "password"]) , //login/gettoken
    "ChildrenFetchAll":APIDetail(apiName: "listChild", cdName: "Children", httpType: .get, JSONField: nil),
    "ChildrenCreate":APIDetail(apiName: "createChild", cdName: "Children", httpType: .post, JSONField: ["nickname", "birthday","weight","weight_lbs","gender"], root: "child"),
    "ChildrenUpdate":APIDetail(apiName: "modifyChild", cdName: "Children", httpType: .put, JSONField: ["x_child_sn", "nickname", "birthday","weight","weight_lbs","gender","unit","current_water_rate"]),
    "ChildrenFetch":APIDetail(apiName: "loadChild", cdName: "Children", httpType: .get, JSONField: ["x_child_sn", "token"], root: "child"),
    "PetsCreate":APIDetail(apiName: "petCreate", cdName: "Pets", httpType: .post, JSONField: ["x_child_sn", "pet_model"]),
    "PetsCreateNext":APIDetail(apiName: "petCreateNext", cdName: "Pets", httpType: .post, JSONField: ["x_child_sn", "pet_model"]),
    "PetsFetchAll":APIDetail(apiName: "getPets", cdName: "Pets", httpType: .get, JSONField: ["x_child_sn"]),
    "CupsFetchAll":APIDetail(apiName: "listCup", cdName: "Cups", httpType: .get, JSONField: ["x_child_sn"]),
    "APIVersionFetch":APIDetail(apiName: "getAPIVersion", cdName: "_", httpType: .get, JSONField: ["x_child_sn"]),
    "FriendsFetchAll":APIDetail(apiName: "listFriends", cdName: "Friends", httpType: .get, JSONField: ["x_child_sn"]),
    "WakeSleepUpdate":APIDetail(apiName: "sleepConfig", cdName: "SchoolTime", httpType: .put, JSONField: nil),
    "WakeSleepFetch":APIDetail(apiName: "sleepConfig", cdName: "WakeSleep", httpType: .get, JSONField: ["x_child_sn","type:sleep"]),
    "SchoolTimeUpdate":APIDetail(apiName: "sleepConfig", cdName: "SchoolTime", httpType: .put, JSONField: nil),
    "SchoolTimeFetch":APIDetail(apiName: "sleepConfig", cdName: "SchoolTime", httpType: .get, JSONField: ["x_child_sn","type:school"]),
    "WaterLogFetch":APIDetail(apiName: "dringLogs", cdName: "WaterLog", httpType: .get, JSONField: ["x_child_sn"]),
    "HabitIdxFetch":APIDetail(apiName: "getScore", cdName: "_", httpType: .get, JSONField: ["x_child_sn"]),
    "setTimezone":APIDetail(apiName: "setTimezone", cdName: "_", httpType: .post, JSONField: nil),
    "checkHealth":APIDetail(apiName: "checkHealth", cdName: "_", httpType: .get, JSONField: nil),
    "diagnostic":APIDetail(apiName: "diagnostic", cdName: "_", httpType: .post, JSONField: nil),
    "getScore":APIDetail(apiName: "getScore", cdName: "_", httpType: .get, JSONField: nil),
    "changePasswd":APIDetail(apiName: "changePasswd", cdName: "_", httpType: .put, JSONField: nil),
    "changeMail":APIDetail(apiName: "changeMail", cdName: "_", httpType: .put, JSONField: nil),
    "uploadPhoto":APIDetail(apiName: "uploadPhoto", cdName: "_", httpType: .post, JSONField: nil),
    "getPhoto":APIDetail(apiName: "uploadPhoto", cdName: "_", httpType: .get, JSONField: nil),
    "checkEmail":APIDetail(apiName: "email", cdName: "_", httpType: .post, JSONField: nil),
    "getVerifyCode":APIDetail(apiName: "verifyCode", cdName: "_", httpType: .post, JSONField: nil),
    "checkCode":APIDetail(apiName: "checkCode", cdName: "_", httpType: .post, JSONField: nil),
    "resetPassword":APIDetail(apiName: "resetPassword", cdName: "_", httpType: .post, JSONField: nil),
    "getPairResult": APIDetail(apiName: "getPairResult", cdName: "_", httpType: .get, JSONField: ["x_child_sn", "ssid"]),
    "CupsDelete": APIDetail(apiName: "unpairCup", cdName: "Cups", httpType: .post, JSONField: ["x_child_sn", "x_cup_id"]),
    "ChildrenDelete" : APIDetail(apiName: "deleteChild", cdName: "Children", httpType: .delete, JSONField:["x_child_sn","nickname"]),
    "checkUpgradePetStatus":APIDetail(apiName: "checkUpgradePetStatus", cdName: "_", httpType: .post, JSONField: nil),
    "PetsUpgrade":APIDetail(apiName: "upgradePet", cdName: "Pets", httpType: .post, JSONField: ["x_child_sn","pet_model","x_cup_id"]),
    "getPetPlants":APIDetail(apiName: "getPetPlants", cdName: "_", httpType: .post, JSONField: nil),
    "getPetsName":APIDetail(apiName: "getPetsName", cdName: "_", httpType: .get, JSONField: nil)
]

//let jsonMapper=["password":"passwd", "name":"userSn"]

let jsonMapper=["x_child_sn":"childID",
                "local_time":"currenttime",  //need getter
    "password":"passwd",
    //"name":"uuid", //need a getter
    "mobile":"mail",
    "nickname":"childName",
    "weight":"weight",
    "photo":"",//need getter
    "x_cup_id":"cupID",
    "created_date":"createdDate",
    "pet_model":"petName",
    "pet_id":"petNum",
    "pet_status":"petStatus",
    "pet_current_level":"petLevel",
    "x_user_token":"token",
    "x_user_sn":"userSn",
    "recommend_water":"recommendWater",
    "has_cup":"hasCup",
    "pet_current_depth":"petDepth",
    "has_pet":"hasPet",
    "weight_lbs":"weightLbs",
    "cup_hw_sn":"cupSN",
    "user_id":"userid",
    "current_water_rate":"water_rate",
]

func getRestAPI (_ name:String, op:Operation) ->APIDetail?
{
    //TODO add key check!
    return cloudAPI[name+op.rawValue]
}



func fillDictionay<T:NSObject>(_ object:T, fields:[String]?) -> [String:AnyObject] {
    let keys = object.keyNames()
    var body=[String:AnyObject]()
    if fields == nil {return [:]}
    for field in fields! {
        if keys.contains(field){
            let val = object.value(forKey: field)
            body[field]=val as AnyObject?
        }else {
            let key = (jsonMapper.index(forKey: field)==nil) ? field : jsonMapper[field]
            if keys.contains("childID") && object.value(forKey: "childID") == nil {
                object.setValue(activeChildID, forKey: "childID")
            }
            if keys.contains(key!) {
                let val = object.value(forKey: key!)
                body[field]=val as AnyObject?
            }else {
                //hard coded key:value
                let key_val = key!.components(separatedBy: ":")
                if key_val.count == 2 {
                    body[key_val[0]] = key_val[1] as AnyObject?
                }
            }
            if field == "name" {
                body[field]=UUID().uuidString as AnyObject?
            }
        }
    }

    return body
}

func fillObject<T:NSObject>(_ object:T, data:NSDictionary) -> Result<NSDictionary> {
    let objectKeys = object.keyNames()
    for (key, val) in data {
        guard let _=jsonMapper.index(forKey: key as! String) else {continue}
        //json key should be in data model
        //update model key
        let jsonKey=jsonMapper[key as! String]!
        if objectKeys.contains(jsonKey) {
            object.setValue(val, forKey: jsonKey)
        }else{
            assertionFailure("map json to data error")
        }
    }
    return .Success(["result":"Success"])
}

class CloudComm: NetComm {
    static let shareObject = CloudComm()
    var token:String?
    var operation : Operation = .fetch
    var callbackOperation : Operation = .fetch
    var requestArray = NSMutableDictionary()
    var handleObject : String?
    
    public func createRESTRequest(_ apiString:String, body:[String:AnyObject]?, callback:@escaping (Result<NSDictionary>)->Void) {
        guard cloudAPI[apiString] != nil else {
            print("no api name")
            return
        }
        
        let api = cloudAPI[apiString]!
        
        operation = .fetch
        
        if api.http == .get {
            httpHttpReq(api, token: token, header: body, netCallback:callback)
        }else{
            httpHttpReq(api, token: token, body: body, netCallback:callback)
        }
        //create
    }
    
    public func createRESTRequest<T:NSObject>(_ objectOps:(T, Operation), callback:@escaping (Result<NSDictionary>)->Void)  {
        //let name=""
        let className=String(describing: type(of: objectOps.0))
        let httpBody:[String:AnyObject]?
        guard let api=getRestAPI(className, op: objectOps.1) else {
            callback(.Error(NSError(domain: "createRESTRequest", code: -1, userInfo:  ["message":"incorrect API"])))
            return
        }
        if api.fields != nil {
            httpBody=fillDictionay(objectOps.0, fields: api.fields!)
        }else{
            if className.contains("Sleep") {
                httpBody=objectOps.0.fillinSleepTimeDict()
            }else if className.contains("School") {
                httpBody=objectOps.0.fillinSchoolDict()
            }else {
                httpBody=nil
            }
        }
        if api.http == .get {
            httpHttpReq(api, token: token, header: httpBody, netCallback:callback)
        }else{
            httpHttpReq(api, token: token, body: httpBody, netCallback:callback)
        }
        requestArray.setValue(objectOps.0, forKey: objectOps.1.rawValue)
        //create
        
    }
    
    func getOperationFromObject(_ handleObject:NSObject) -> Operation {
        for (key,value) in requestArray {
            if handleObject == value as? NSObject{
                requestArray.removeObject(forKey: key)
                return Operation(rawValue: key as! String)!
            }
        }
        return .fetch
    }
    
    func getAPIVersion(_ cloudCallback:@escaping (Result<NSDictionary>)->Void )  {
        let config = ["x_child_sn":activeChildID]
        
        createRESTRequest("APIVersionFetch",
                   body:config as [String : AnyObject]?, callback:cloudCallback)
    }
    
    func resetNewPassword(_ email:String,password:String,agianPassword:String,verification_key:String,cloudCallback:@escaping (Result<NSDictionary>)->Void) {
        createRESTRequest("resetPassword", body: ["email":email as AnyObject,"new_password":password as AnyObject,"new_password_confirm":agianPassword as AnyObject,"verification_key":verification_key as AnyObject], callback: cloudCallback)
    }
    
    func checkUserEmailVerifyCode(_ email:String , verifyCode:String,cloudCallback:@escaping (Result<NSDictionary>)->Void) {
        createRESTRequest("checkCode", body: ["email":email as AnyObject,"verification_key":verifyCode as AnyObject], callback: cloudCallback)
    }
    
    func sendUserEmailVerifyCode(_ email:String , cloudCallback:@escaping (Result<NSDictionary>)->Void) {
        createRESTRequest("getVerifyCode", body: ["email":email as AnyObject], callback: cloudCallback)
    }
    
    func checkUserEmailAvailable(_ email:String , cloudCallback:@escaping (Result<NSDictionary>)->Void) {
        createRESTRequest("checkEmail", body: ["email":email as AnyObject], callback: cloudCallback)
    }
    func checkHealth(_ cloudCallback:@escaping (Result<NSDictionary>)->Void)  {
        createRESTRequest("checkHealth", body: nil, callback: cloudCallback)
    }
    
    func uploadDiagnostic(_ diagnostic: String, cloudCallback: @escaping (Result<NSDictionary>)->Void){
        let diagDict = ["diagnostic":diagnostic]
        createRESTRequest("diagnostic", body: diagDict as [String : AnyObject]?, callback: cloudCallback)
    }
    


}
