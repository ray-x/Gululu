//
//  NetComm.swift
//  Gululu
//
//  Created by Ray Xu on 30/10/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import Foundation
import UIKit

typealias ServiceResponseFR = ( ( Result<NSDictionary>) -> Void )
class NetComm: NSObject {
    let failure=NSError(domain: "httptReq", code: 100, userInfo: nil)
    var requestHeader:String!
    let requestHelper = GHHttpHelper.share
    
    let API = [ "users":"/d/users",
                "email":"/m/email",
                "verifyCode":"/m/user/password/sendkeybyemail",
                "checkCode":"/m/user/password/checkcode",
                "resetPassword":"/m/user/password/reset",
                "user":"/m/user",
                "loadChild":"/m/child",
                "createChild":"/m/child",
                "modifyChild":"/m/child",
                "login":"/m/user/login",
                "pairCup":"/m/user/cup",
                "dringLogs":"/m/child/drinking-logs",
                "sleepConfig":"/m/child/configs",
                "listChild":"/m/children",
                "listCup":"/m/child/cups",
                "listFriends":"/m/child/friends",
                "petCreate":"/m/child/pet",
                "getPets":"/m/child/pets",
                "petCreateNext":"/m/child/next_pet",
                "setTimezone":"/m/child/timezone",
                "getAPIVersion":"/m/version",
                "uploadPhoto":"/m/child/profile",
                "getRecWater":"/m/recommend_water",
                "checkHealth":"/m/health",
                "getScore":"/m/child/habit-score",
                "changeMail":"/m/user/email",
                "changePasswd":"/m/user/password",
                "diagnostic": "/m/diagnostic",
                "getPairResult": "/m/cup/pair",
                "unpairCup": "/m/cup/unpair",
                "deleteChild":"/m/child",
                "checkUpgradePetStatus":"/m/cup_upgrade_status",
                "upgradePet":"/m/child/upgrade_pet",
                "getPetPlants":"/m/pet/getPlants",
                "getPetsName":"/m/child/pet_options"
                ]
    var post:NSDictionary?
    var get:NSDictionary?
    var put:NSDictionary?
    var delete:NSDictionary?
    let buildVersion =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    override init () {
        requestHeader = "Gululu/\(AppData.share.App_version!);iOS/\(AppData.share.OS_version!);apple/\(AppData.share.model_type!)"
        super.init()
    }

    func httpHttpReq(_ req: APIDetail, token:String?=nil, header: [String: AnyObject]?=nil, body: [String: AnyObject]?=nil, netCallback: @escaping ServiceResponseFR){
        httpReq(req, token: token, header: header, body: body, netCallback: { result in
            guard result.boolValue == false  else{
                netCallback(result)
                return
            }
            let err = result.error! as NSError
            print(err.userInfo)
            let errcode = err.userInfo["status_code"] as? Int
            
            guard errcode != nil else{
                netCallback(result)
                return
            }
            guard errcode == 401 else{
                netCallback(result)
                return
            }
            
            GUser.share.checkUserPassword({ resultBool in
                if resultBool {
                    self.httpReq(req, token: token, header: header, body: body, netCallback: netCallback)
                }else{
                    netCallback(result)
                }
            })

        })
    }

    fileprivate func httpReq(_ req: APIDetail, token:String?=nil, header: [String: AnyObject]?=nil, body: [String: AnyObject]?=nil, netCallback: @escaping ServiceResponseFR){
        let reqAPI=req.name
        let ops=req.http
        guard let strAPI=API[reqAPI] else{
            print("invalid request")
            return
        }

        let config = URLSessionConfiguration.default
        _ = URLSession(configuration: config)
        let url = requestHelper.postURL+strAPI
        let httpRequest=NSMutableURLRequest(url:URL(string: url)!)
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.addValue(requestHeader, forHTTPHeaderField: "Gululu-Agent")
        httpRequest.addValue(AppData.share.getUUID_from_keyChain(), forHTTPHeaderField: "udid")
        httpRequest.addValue(AppData.share.phoneLanguageFirst, forHTTPHeaderField: "Accept-Language")
        httpRequest.httpMethod=ops.rawValue

        if let httpToken=token{
            httpRequest.addValue(httpToken, forHTTPHeaderField: "token")
        }else{
            print(req)
            print("token empty")
        }

        //prepare the data
        if header != nil {
            header?.forEach({
                httpRequest.addValue($0.1 as! String, forHTTPHeaderField: $0.0)
                print($0.1, $0.0)
            })
        }
        
        if body != nil {
            let value = body?["diagnostic"]
            if value != nil{
                do{
                    let valueIn : String? = (body?["diagnostic"])! as? String
                    let jsonPost = valueIn?.data(using: String.Encoding.utf8)
                    httpRequest.httpBody=jsonPost

                    httpRequest.setValue("form", forHTTPHeaderField: "Content-Type")
                }
            }else{
                do{
                    let jsonPost=try JSONSerialization.data(withJSONObject: body!, options: [])
                    httpRequest.httpBody=jsonPost
                    let theJSONText = NSString(data: httpRequest.httpBody!,
                                               encoding: String.Encoding.utf8.rawValue)
                    print("JSON string = \(theJSONText!)")
                    
                }catch {
                    print("post data error")
                    assertionFailure("http Body empyt")
                    return
                }
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: {
            (data, response, error) in
            guard let responsData=data else{
                print("error NO data recevied")
                netCallback(Result(error: self.failure))
                return
            }
            guard error==nil else {
                print("erro in POST")
                netCallback(Result(error: self.failure))
                return
            }
            
            do {
                let post = try JSONSerialization.jsonObject(with: responsData, options: []) as? NSDictionary
                if post == nil {
                    netCallback(Result(error: self.failure))
                    print (" status ERROR; nil in post")
                }else{
                    print("The response is: " + post!.description)
                    
                    guard  let status=post!["status"] as? String else{
                        netCallback(Result(error: self.failure))
                        return
                    }
                    if status != "OK" {
                        if post!["status"] != nil{
                            print (" status ERROR \(String(describing: post!["status"] as? String))")
                        }
                        let error=NSError(domain: "httptReq", code: 100, userInfo: post! as? [AnyHashable: Any] as? [String : Any])
                        netCallback (Result(error: error))
                    }else{
                        if req.root != nil && post![req.root!] != nil {
                            netCallback(Result(success: (post![req.root!] as! NSDictionary)))
                        }else{
                            netCallback(Result(success: post!))
                        }
                    }
                }
            } catch {
                print ("error pasrse response from POST")
                netCallback(Result(error: self.failure))
                return
            }
        })
        dataTask.resume()
    }
}

