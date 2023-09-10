//
//  GHHttpHelper.swift
//  Gululu
//
//  Created by Baker on 17/3/6.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

enum Service {
    case product
    case staging
    case dev
    case dev2
    case baker
    case will
}

class GHHttpHelper: NSObject {
    
    static let share = GHHttpHelper()
    
    var token = ""
    var requsetDicArr = NSMutableArray()
    
    var postURL = ""
    var postURLBackup = ""
    var postURLGlobal = ""
    var requestHeader = ""
    
    override init() {
        if service == .product{
            postURL         = "https://api.gululu-a.com:9443/api/v1"
            postURLBackup   = "https://m.api.gululu-c.com:9443/api/v1"
            postURLGlobal   = "https://api.gululu-c.com:9443/api/v1"
        }else if service == .staging {
            postURL         = "http://staging.cn.mygululu.com:9000/api/v1"
            postURLBackup   = "http://staging.cn.mygululu.com:9000/api/v1"
            postURLGlobal   = "http://staging.cn.mygululu.com:9000/v1"
        }else if service == .dev {
            postURL         = "http://dev.cn.mygululu.com:9000/api/v1"
            postURLBackup   = "http://dev.cn.mygululu.com:9000/api/v1"
            postURLGlobal   = "http://dev.cn.mygululu.com:9000/v1"
        }else if service == .baker {
            postURL         = "http://127.0.0.1:5000/api/v1"
            postURLBackup   = "http://127.0.0.1:5000/api/v1"
            postURLGlobal   = "http://127.0.0.1:5000/v1"
        }else if service == .dev2 {
            postURL         = "http://dev2.cn.mygululu.com:9000/api/v1"
            postURLBackup   = "http://dev2.cn.mygululu.com:9000/api/v1"
            postURLGlobal   = "http://dev2.cn.mygululu.com:9000/v1"
        }else if service == .will{
            postURL         = "http://192.168.8.102:5000/api/v1"
            postURLBackup   = "http://dev2.cn.mygululu.com:9000/api/v1"
            postURLGlobal   = "http://dev2.cn.mygululu.com:9000/v1"
        }
        requestHeader = "Gululu/\(AppData.share.App_version!);iOS/\(AppData.share.OS_version!);apple/\(AppData.share.model_type!)"
    }
    
    func connserv()  {
        var request = URLRequest(url: URL(string: postURL+"/m/health")!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("Firing synchronous url connection......")
        let data =  URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil{
                self.postURL = self.postURLGlobal
                request = URLRequest(url: URL(string: self.postURL+"/m/health")!)
                let data2 = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if error != nil{
                        self.postURL = self.postURLBackup
                    }
                })
                data2.resume()
            }
        })
        data.resume()
        
    }
    
    static func show_server_error(){
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: BASE_FRAME)
        alertView.initAlertContent("", message:  Localizaed("The connection to the server failed. Please try again later"), leftBtnTitle: OK, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    

}
