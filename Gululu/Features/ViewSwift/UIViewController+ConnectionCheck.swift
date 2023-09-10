//
//  UIViewController+ConnectionCheck.swift
//  Gululu
//
//  Created by Ray Xu on 8/05/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import Foundation
import UIKit

/**
 Used to expose public API on view controllers
 */
extension BaseViewController {
    
    func displayNoInternetConnectionBanner() {
        let uInfo = GUser.share
        let popHeight=view.bounds.width*0.22
        let popWidth=view.bounds.width
        
        let InternetWarningMsgbox=WifiPopupView(frame: CGRect(x: 0, y: -popHeight, width: popWidth, height: popHeight))
        if !uInfo.showBanner {
            uInfo.showBanner=true
        }else{
            return
        }
        navigationController?.navigationController?.setToolbarHidden(true, animated: false)
        InternetWarningMsgbox.alpha=1.0
        view.addSubview(InternetWarningMsgbox)
        view.bringSubview(toFront: InternetWarningMsgbox)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations: {
            InternetWarningMsgbox.center.y = popHeight*0.5
            }, completion: {
                (success) in
                let delay = 3.5 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                        InternetWarningMsgbox.center.y = -popHeight*0.5
                        }, completion: { (ret) in
                            DispatchQueue.main.async{
                                uInfo.showBanner=false
                            }
                    })
                })
        })
    }
    
    func isConnectNet() -> Bool {
        let connStatus = NetworkStatusNotifier()
        
        switch connStatus.connectionStatus(){
        case .unknown, .offline:
            return false
        case .online(.wiFi), .online(.wwan):
            if PairCupHelper.share.isConnetGululuAP(){
                return false
            }
            return true
        }
    }
    
    func checkInternetConnection() -> Bool {
        let connStatus = NetworkStatusNotifier()
        
        switch connStatus.connectionStatus(){
        case .unknown, .offline:
            displayNoInternetConnectionBanner()
            return false
        case .online(.wiFi), .online(.wwan):
            if PairCupHelper.share.isConnetGululuAP(){
                displayNoInternetConnectionBanner()
                return false
            }
            return true
        }
    }
    
    func checkNetIsNeedShowRedSign() {
        let connStatus = NetworkStatusNotifier()
        
        switch connStatus.connectionStatus(){
        case .unknown, .offline:
            displayNoInternetConnectionBanner()
        case .online(.wiFi), .online(.wwan):
            if PairCupHelper.share.isConnetGululuAP(){
                displayNoInternetConnectionBanner()
            }
        }
    }

}
