//
//  AlterView.swift
//  Gululu
//
//  Created by baker on 2018/6/15.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

class AlterView: NSObject {
    static func showConnectServerError() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: (UIApplication.shared.keyWindow?.frame)!)
        alertView.initAlertContent("", message: Localizaed("Please try again later"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
}
