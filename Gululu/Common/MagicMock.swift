//
//  File.swift
//  Gululu
//
//  Created by baker on 2017/12/14.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

class Test_class: NSObject {
    
    let test_name1: String? = nil
    let test_name2 = "test_str"
    var test_name3: String?
    var test_name4 = "test_str_var"
    
    func my_fun1() {
        
    }
    
    func my_fun2() -> Bool {
        return false
    }
    
    @objc func my_fun3() -> Int {
        return 3
    }
    
    func my_fun4(_ str:String?) -> Bool {
        if str == nil{
            return false
        }else{
            return true
        }
    }
    
    
}

class MagicMock: NSObject {
    
    var returnValue: String?
    
//    init(_ className: AnyClass) {
//
//    }
//
//    ini
    
    @objc func mock() -> String{
        return returnValue!
    }
    
    func return_value(_ className: AnyClass,  originalSelector: Selector){
//        let originalSelector = Selector(funName)
//        var mtrhonINT:UInt32 = 0
//        let methond_list = class_copyMethodList(className, &mtrhonINT)
//        for index in 0..<numericCast(mtrhonINT) {
//            let method: Method = methond_list![index]
//            let uft8Type =  method_getTypeEncoding(method)
//
//            print(uft8Type)
//
//            let uft8copy =  method_copyReturnType(method)
//
//            print(uft8copy)
//            print(String(_sel:method_getName(method)))
//        }
        
        let originalMethod = class_getInstanceMethod(className, originalSelector)
        let swizzledSelector = #selector(MagicMock.mock)
        let swizzledMethod = class_getInstanceMethod(MagicMock.self, swizzledSelector)
        let strSt =  Test_class().my_fun3()
        print(strSt)
        let didAddMethod = class_addMethod(className, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(MagicMock.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
        
        let strSt1 =  Test_class().my_fun3()
        print(strSt1)
//        method_exchangeImplementations(originMethod!, swiftMethod!)
    }
}
