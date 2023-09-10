//
//  GUHttpRequest.swift
//  Gululu
//
//  Created by Baker on 17/3/3.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class GUHttpRequest: NSObject {

    var httpRequest = NSMutableURLRequest()
    let requestHelper = GHHttpHelper.share
    let requestTag = ""
    
    typealias ServiceResponseFR = ( ( Result<NSDictionary>) -> Void )
    let failure=NSError(domain: "httptReq", code: 100, userInfo: nil)
    let header = NSMutableDictionary()
    let body = NSMutableDictionary()
    var lastApiString = ""
    var httpType:HttpType = .get
    
    func setRequestConfig(_ method : HttpType, url : String) {
        lastApiString = url
        httpType = method
    }
    
    public func handleRequset(callback:@escaping (Result<NSDictionary>)->Void) {
        let url = requestHelper.postURL + lastApiString
        httpRequest = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0)
        setHeaderAndSession()
        httpHttpReq(netCallback: callback)
    }
    
    private func httpHttpReq(netCallback: @escaping ServiceResponseFR){
        handleHttpRequest(netCallback: { result in
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
                    self.handleHttpRequest(netCallback: netCallback)
                }else{
                    netCallback(result)
                }
            })
        })
    }

    private func setHeaderAndSession() {
        let config = URLSessionConfiguration.default
        _ = URLSession(configuration: config)
        
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.addValue(requestHelper.requestHeader, forHTTPHeaderField: "Gululu-Agent")
        httpRequest.addValue(AppData.share.getUUID_from_keyChain(), forHTTPHeaderField: "udid")
        httpRequest.addValue(requestHelper.token, forHTTPHeaderField: "token")
        httpRequest.addValue(AppData.share.phoneLanguageFirst, forHTTPHeaderField: "Accept-Language")
        httpRequest.httpMethod = httpType.rawValue
        
        //prepare the data
        if header.count != 0 {
            header.forEach({
                httpRequest.addValue($0.1 as! String, forHTTPHeaderField: $0.0 as! String)
                print($0.1, $0.0)
            })
        }
        
        if body.count != 0 {
            let value = body["diagnostic"]
            if value != nil{
                do{
                    let valueIn : String? = (body["diagnostic"])! as? String
                    let jsonPost = valueIn?.data(using: String.Encoding.utf8)
                    httpRequest.httpBody=jsonPost
                    httpRequest.setValue("form", forHTTPHeaderField: "Content-Type")
                }
                
            }else{
                do{
                    let jsonPost=try JSONSerialization.data(withJSONObject: body, options: [])
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
    }

   private func handleHttpRequest(netCallback: @escaping ServiceResponseFR) {
        
        let dataTask=URLSession.shared.dataTask(with: httpRequest as URLRequest, completionHandler: {
            (data, response, error) in
            guard let responsData = data else{
                print("error NO data recevied")
                BH_ERROR_LOG("error NO data recevied")
                netCallback(Result(error: self.failure))
                return
            }
            guard error == nil else {
                print("erro in POST")
                BH_ERROR_LOG("erro in POST")
                netCallback(Result(error: self.failure))
                return
            }
            
            do {
                let post = try JSONSerialization.jsonObject(with: responsData, options: []) as? NSDictionary
                guard post != nil else{
                    netCallback(Result(error: self.failure))
                    print (" status ERROR; nil in post")
                    BH_ERROR_LOG("post is nil")
                    return
                }
               
                print("The response is: " + post!.description)
                
                guard  let status=post!["status"] as? String else{
                    netCallback(Result(error: self.failure))
                    return
                }
                
                if status != "OK" {
                    if post!["status"] != nil{
                        let errorStr = "status ERROR \(String(post!.description))"
                        BH_ERROR_LOG(errorStr)
                    }
                    let error = NSError(domain: "httptReq", code: 100, userInfo: post! as? [AnyHashable: Any] as? [String : Any])
                    netCallback(Result(error: error))
                }else{
                    netCallback(Result(success: post!))
                }
            } catch {
                let errorStr = String(format:"POST - Catch - RequestURL:%@", (self.httpRequest.url?.absoluteString)!)
                BH_ERROR_LOG(errorStr)
                print ("error pasrse response from POST")
                netCallback(Result(error: self.failure))
                return
            }
        })
        dataTask.resume()
    }
    
}
