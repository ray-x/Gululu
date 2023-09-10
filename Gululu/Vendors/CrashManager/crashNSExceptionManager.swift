//
//  crashNSExceptionManager.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/15.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//  用于捕获OC的NSException导致的异常崩溃

import UIKit


func registerUncaughtExceptionHandler() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler)
}

func UncaughtExceptionHandler(exception: NSException) {
    let arr = exception.callStackSymbols
    let reason = exception.reason
    let name = exception.name.rawValue
    var crash = String()
    crash += "Stack: "
    crash = crash.appendingFormat("slideAdress:0x%0x\r", calculate())
    crash += "\r name:\(name) \r reason:\(String(describing: reason)) \r \(arr.joined(separator: "\r")) \r"
    CrashManager.saveCrash(appendPathStr: .nsExceptionCrashPath, exceptionInfo: crash)
}

